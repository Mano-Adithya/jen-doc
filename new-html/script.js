// script.js

// Function to create a section with a title, description, and link
function createSection(title, description, linkText, linkUrl) {
    const section = document.createElement('div');

    const h1 = document.createElement('h1');
    h1.textContent = title;
    section.appendChild(h1);

    const p = document.createElement('p');
    p.textContent = description;
    section.appendChild(p);

    const a = document.createElement('a');
    a.textContent = linkText;
    a.href = linkUrl;
    section.appendChild(a);

    document.body.appendChild(section);
}

// Determine which page to display based on the URL or other logic
if (window.location.pathname.includes('index.html')) {
    createSection('Welcome to HTML1 by Mano', 'This is the first microservice.', 'Go to HTML2 Microservice', 'http://13.233.119.99:8082');
} else if (window.location.pathname.includes('index2.html')) {
    createSection('Hello from Another HTML Page!', 'This is the second microservice.', 'Go to HTML1 Microservice', 'http://13.233.119.99:8081');
}
