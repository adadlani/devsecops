import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  template: `
    <h1>Hello World from Angular!</h1>
    <button (click)="callBackend()">Call Spring Backend</button>
    <div *ngIf="backendMessage">Backend says: {{ backendMessage }}</div>
  `,
})
export class AppComponent {
  backendMessage?: string;
  constructor(private http: HttpClient) {}
  callBackend() {
    this.http.get('/api/log', { responseType: 'text' }).subscribe(msg => this.backendMessage = msg);
  }
}
