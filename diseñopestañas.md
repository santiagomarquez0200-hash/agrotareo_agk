login
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "tertiary-fixed-dim": "#f2bb98", "secondary-fixed-dim": "#75daa8", "on-tertiary-container": "#cf9b7a", "on-secondary-fixed-variant": "#005235", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "tertiary": "#3d1e07", "primary": "#012d1d", "surface-dim": "#d9dadb", "surface-tint": "#3f6653", "on-primary-container": "#86af99", "inverse-on-surface": "#f0f1f2", "on-primary-fixed-variant": "#274e3d", "on-surface": "#191c1d", "tertiary-container": "#57331a", "surface-container-lowest": "#ffffff", "secondary-fixed": "#92f7c3", "error": "#ba1a1a", "inverse-primary": "#a5d0b9", "surface-container-low": "#f3f4f5", "on-secondary": "#ffffff", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "surface": "#f8f9fa", "background": "#f8f9fa", "primary-container": "#1b4332", "on-error-container": "#93000a", "surface-bright": "#f8f9fa", "primary-fixed": "#c1ecd4", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "secondary": "#006c48", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "tertiary-fixed": "#ffdcc7", "outline": "#717973", "on-secondary-container": "#00734d", "surface-container-highest": "#e1e3e4", "surface-container": "#edeeef", "on-secondary-fixed": "#002113", "error-container": "#ffdad6", "on-background": "#191c1d", "secondary-container": "#92f7c3", "on-primary": "#ffffff", "on-error": "#ffffff", "on-tertiary-fixed": "#301401" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "lg": "24px", "gutter": "16px", "margin-desktop": "32px", "base": "8px", "xl": "40px", "xs": "4px", "sm": "12px", "margin-mobile": "16px", "md": "16px" }, "fontFamily": { "body-md": ["Inter"], "body-lg": ["Inter"], "headline-lg-mobile": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "title-md": ["Inter"], "display-lg": ["Inter"], "label-sm": ["Inter"] } } } }</script><style>@layer base { .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0); } .pt-safe { padding-top: env(safe-area-inset-top, 0); } } </style></head><body class="bg-background text-on-surface font-body-md overflow-x-hidden pt-safe pb-safe"><main class="min-h-screen w-full relative flex flex-col"><div class="flex flex-col w-full h-full relative flex-1 min-h-[100dvh]">
<!-- Background Image with Overlay -->
<div class="absolute inset-0 z-0 bg-cover bg-center" style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCR7fQ8F8MTI8pYVZGdrL2DJPZSQwOxqf-XKS2JRtgl9BXWXReXuFLCQKoHEKOnyjyXmcrqan9lGhMgh5FH9MIj0pUKW8qpDe_aONIZPYSkcNg2juzDSgFhZ2gPxH-FFZSaeeE_DBnlmgTJ5Sr2Vmtf6IqPuInGQs6DF1rFn7-fVRWdJjcMyx6rBO42C8Ybv3n38A5UhrREsURud4_KhvvhYrrup6SKlMK_88Xmo61F8505TKz_DHA1xg');">
<div class="absolute inset-0 bg-gradient-to-b from-surface/40 via-surface/80 to-surface backdrop-blur-[2px]"></div>
</div>
<!-- Main Content Container -->
<div class="relative z-10 flex flex-col items-center justify-center flex-1 w-full px-margin-mobile py-xl max-w-md mx-auto h-full">
<!-- Logo Header -->
<div class="flex flex-col items-center mb-xl">
<div class="w-24 h-24 mb-sm rounded-xl overflow-hidden shadow-sm bg-surface-container-lowest">
<img alt="AgroTareo Logo" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAFGqZSx_WjtSni2vRO4rm5mQr_cyIxNg3YFdmWa8XEeXcJaQRDUi_MQmO0OjhCKLnt65ExH4EXM5kEqE5WabUUj81BchHQ7GHBqS_fmmj4cMnKFvPn8_ELQ4KvUYimpnF-HoX_C10m0exj_WhOlZj_Wgl6WDkOVK3DXikt9kEEEmLM6zs-wGSCOpmBBD_L-LaICnBlPVKQGkqdN-azG_05qGcCfSgM7_6R6GpC2nYQXsKd1rWdHFc5gQ">
</div>
<h1 class="font-headline-lg-mobile text-on-surface text-center tracking-tight text-balance">
                Bienvenido a AgroTareo
            </h1>
<p class="font-body-md text-on-surface-variant text-center mt-xs">
                Gestión agrícola eficiente y precisa
            </p>
</div>
<!-- Login Form Card -->
<div class="w-full bg-surface-container-lowest rounded-xl shadow-[0_8px_16px_rgba(0,0,0,0.04)] p-margin-mobile border border-surface-variant/50">
<form class="flex flex-col gap-gutter" id="loginForm">
<!-- Usuario Input -->
<div class="flex flex-col gap-xs">
<label class="font-label-md text-on-surface-variant pl-xs" for="username">Usuario</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-on-surface-variant group-focus-within:text-primary transition-colors">person</span>
<input class="w-full h-[56px] pl-[44px] pr-sm rounded-lg bg-surface-container-low border-2 border-transparent focus:border-primary focus:bg-surface-container-lowest focus:outline-none transition-all font-body-md text-on-surface placeholder:text-on-surface-variant/50" id="username" name="username" placeholder="Ej: admin123" required="" type="text">
</div>
</div>
<!-- Contraseña Input -->
<div class="flex flex-col gap-xs">
<label class="font-label-md text-on-surface-variant pl-xs" for="password">Contraseña</label>
<div class="relative group">
<span class="material-symbols-outlined absolute left-sm top-1/2 -translate-y-1/2 text-on-surface-variant group-focus-within:text-primary transition-colors">lock</span>
<input class="w-full h-[56px] pl-[44px] pr-[44px] rounded-lg bg-surface-container-low border-2 border-transparent focus:border-primary focus:bg-surface-container-lowest focus:outline-none transition-all font-body-md text-on-surface placeholder:text-on-surface-variant/50" id="password" name="password" placeholder="••••••••" required="" type="password">
<button aria-label="Mostrar contraseña" class="absolute right-sm top-1/2 -translate-y-1/2 text-on-surface-variant hover:text-on-surface p-xs h-[44px] w-[44px] flex items-center justify-center rounded-full transition-colors active:bg-surface-container" id="togglePassword" type="button">
<span class="material-symbols-outlined" id="togglePasswordIcon">visibility</span>
</button>
</div>
</div>
<!-- Forgot Password Link -->
<div class="flex justify-end mt-[-4px]">
<a class="font-label-md text-primary hover:text-primary-container transition-colors py-xs px-xs" href="#">
                        ¿Olvidaste tu contraseña?
                    </a>
</div>
<!-- Submit Button -->
<button class="mt-xs w-full h-[56px] bg-primary text-on-primary font-label-md rounded-lg flex items-center justify-center gap-xs shadow-sm hover:shadow-md hover:bg-primary-container active:scale-[0.98] transition-all relative overflow-hidden group" id="submitBtn" type="submit">
<span class="relative z-10 flex items-center gap-xs transition-transform duration-300" id="btnText">
                        Iniciar Sesión
                        <span class="material-symbols-outlined text-[20px]">arrow_forward</span>
</span>
<!-- Loading Spinner (Hidden by default) -->
<div class="absolute inset-0 flex items-center justify-center opacity-0 translate-y-4 transition-all duration-300" id="btnSpinner">
<svg class="animate-spin h-5 w-5 text-on-primary" fill="none" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
<path class="opacity-75" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z" fill="currentColor"></path>
</svg>
</div>
</button>
</form>
</div>
<!-- Footer Links -->
<div class="mt-lg text-center">
<p class="font-body-md text-on-surface-variant">
                ¿No tienes una cuenta? 
                <a class="font-label-md text-primary hover:text-primary-container ml-xs underline decoration-primary/30 underline-offset-4" href="#">
                    Crear una cuenta
                </a>
</p>
</div>
</div>
<!-- Offline Status Indicator (Demonstrating robust field app capability) -->
<div class="fixed top-safe left-0 right-0 bg-error text-on-error font-label-sm text-center py-xs transform -translate-y-full transition-transform duration-300 z-50 flex items-center justify-center gap-xs shadow-md" id="offlineIndicator">
<span class="material-symbols-outlined text-[16px]">cloud_off</span>
        Sin conexión a internet
    </div>
<script>
        document.addEventListener('DOMContentLoaded', () => {
            const togglePasswordBtn = document.getElementById('togglePassword');
            const passwordInput = document.getElementById('password');
            const togglePasswordIcon = document.getElementById('togglePasswordIcon');
            const form = document.getElementById('loginForm');
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const btnSpinner = document.getElementById('btnSpinner');

            // Password Toggle Logic
            togglePasswordBtn.addEventListener('click', () => {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                togglePasswordIcon.textContent = type === 'password' ? 'visibility' : 'visibility_off';
                
                // Add a subtle pop animation to the icon
                togglePasswordIcon.classList.add('scale-125');
                setTimeout(() => togglePasswordIcon.classList.remove('scale-125'), 150);
            });

            // Simulate form submission
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                
                // Animate button to loading state
                btnText.classList.add('opacity-0', '-translate-y-4');
                btnSpinner.classList.remove('opacity-0', 'translate-y-4');
                submitBtn.classList.add('cursor-not-allowed', 'opacity-90');
                submitBtn.disabled = true;

                // Simulate network request
                setTimeout(() => {
                    // Reset button state (in a real app this would redirect)
                    btnText.classList.remove('opacity-0', '-translate-y-4');
                    btnSpinner.classList.add('opacity-0', 'translate-y-4');
                    submitBtn.classList.remove('cursor-not-allowed', 'opacity-90');
                    submitBtn.disabled = false;
                    
                    // Add success ripple effect
                    const ripple = document.createElement('div');
                    ripple.className = 'absolute inset-0 bg-secondary/20 mix-blend-overlay animate-[ping_0.5s_cubic-bezier(0,0,0.2,1)_1] rounded-lg pointer-events-none';
                    submitBtn.appendChild(ripple);
                    setTimeout(() => ripple.remove(), 500);

                }, 1500);
            });

            // Simulate Offline Detection (Useful for field apps)
            const offlineIndicator = document.getElementById('offlineIndicator');
            
            function updateOnlineStatus() {
                if (navigator.onLine) {
                    offlineIndicator.classList.add('-translate-y-full');
                } else {
                    offlineIndicator.classList.remove('-translate-y-full');
                }
            }

            window.addEventListener('online', updateOnlineStatus);
            window.addEventListener('offline', updateOnlineStatus);
            // Initial check
            updateOnlineStatus();
        });
    </script>
</div></main></body></html>
menu
<!DOCTYPE html>

<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        "colors": {
                "on-tertiary-fixed-variant": "#643e24",
                "secondary": "#006c48",
                "secondary-container": "#92f7c3",
                "on-error": "#ffffff",
                "surface-container-highest": "#e1e3e4",
                "on-tertiary-fixed": "#301401",
                "primary-container": "#1b4332",
                "on-error-container": "#93000a",
                "on-primary-fixed-variant": "#274e3d",
                "background": "#f8f9fa",
                "on-primary": "#ffffff",
                "surface-variant": "#e1e3e4",
                "on-tertiary": "#ffffff",
                "outline-variant": "#c1c8c2",
                "on-secondary-fixed-variant": "#005235",
                "on-surface": "#191c1d",
                "secondary-fixed-dim": "#75daa8",
                "surface-dim": "#d9dadb",
                "tertiary": "#3d1e07",
                "inverse-primary": "#a5d0b9",
                "surface-bright": "#f8f9fa",
                "tertiary-fixed-dim": "#f2bb98",
                "surface-container-lowest": "#ffffff",
                "primary": "#012d1d",
                "surface-tint": "#3f6653",
                "tertiary-fixed": "#ffdcc7",
                "outline": "#717973",
                "inverse-surface": "#2e3132",
                "on-primary-fixed": "#002114",
                "error-container": "#ffdad6",
                "surface": "#f8f9fa",
                "on-background": "#191c1d",
                "secondary-fixed": "#92f7c3",
                "on-secondary-container": "#00734d",
                "primary-fixed-dim": "#a5d0b9",
                "surface-container-low": "#f3f4f5",
                "on-surface-variant": "#414844",
                "error": "#ba1a1a",
                "inverse-on-surface": "#f0f1f2",
                "primary-fixed": "#c1ecd4",
                "surface-container-high": "#e7e8e9",
                "tertiary-container": "#57331a",
                "on-tertiary-container": "#cf9b7a",
                "on-secondary-fixed": "#002113",
                "surface-container": "#edeeef",
                "on-primary-container": "#86af99",
                "on-secondary": "#ffffff"
        },
        "borderRadius": {
                "DEFAULT": "0.25rem",
                "lg": "0.5rem",
                "xl": "0.75rem",
                "full": "9999px"
        },
        "spacing": {
                "margin-mobile": "16px",
                "lg": "24px",
                "sm": "12px",
                "xs": "4px",
                "xl": "40px",
                "md": "16px",
                "base": "8px",
                "gutter": "16px",
                "margin-desktop": "32px"
        },
        "fontFamily": {
                "headline-lg": [
                        "Inter"
                ],
                "label-md": [
                        "Inter"
                ],
                "headline-lg-mobile": [
                        "Inter"
                ],
                "body-md": [
                        "Inter"
                ],
                "body-lg": [
                        "Inter"
                ],
                "title-md": [
                        "Inter"
                ],
                "display-lg": [
                        "Inter"
                ],
                "label-sm": [
                        "Inter"
                ]
        },
        "fontSize": {
                "headline-lg": [
                        "32px",
                        {
                                "lineHeight": "40px",
                                "fontWeight": "600"
                        }
                ],
                "label-md": [
                        "14px",
                        {
                                "lineHeight": "20px",
                                "letterSpacing": "0.01em",
                                "fontWeight": "500"
                        }
                ],
                "headline-lg-mobile": [
                        "24px",
                        {
                                "lineHeight": "32px",
                                "fontWeight": "600"
                        }
                ],
                "body-md": [
                        "16px",
                        {
                                "lineHeight": "24px",
                                "fontWeight": "400"
                        }
                ],
                "body-lg": [
                        "18px",
                        {
                                "lineHeight": "28px",
                                "fontWeight": "400"
                        }
                ],
                "title-md": [
                        "20px",
                        {
                                "lineHeight": "28px",
                                "fontWeight": "600"
                        }
                ],
                "display-lg": [
                        "48px",
                        {
                                "lineHeight": "56px",
                                "letterSpacing": "-0.02em",
                                "fontWeight": "700"
                        }
                ],
                "label-sm": [
                        "12px",
                        {
                                "lineHeight": "16px",
                                "letterSpacing": "0.05em",
                                "fontWeight": "600"
                        }
                ]
        }
},
    },
  }
</script><style>@layer base { body { -webkit-tap-highlight-color: transparent; overscroll-behavior-y: contain; } .pt-safe { padding-top: env(safe-area-inset-top, 0px); } .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0px); } } .sidebar-transition { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }</style><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
</head><body class="bg-background font-body-md text-on-background"><header class="fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] pt-safe"><div class="h-16 px-margin-mobile flex items-center justify-between"><div class="flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full active:bg-surface-container-high" onclick="document.getElementById('side-nav').classList.remove('-translate-x-full')"><span class="material-symbols-outlined text-on-surface">menu</span></button><img alt="Logo" class="h-8 w-auto object-contain" src="https://lh3.googleusercontent.com/aida/AP1WRLvzrrQ44Q7SKTpREEJaFwcaBJ2_fBqfNQLCtbFCkDcQfKbdqEpLqrtZyyxri5IaN9RFr0wlbyOe-DXSJTClDjo3dViJZ-LrtibMw-B0Y9tsOOA0mXcCZzbEhlogoO1A1QtD_cbixHoCMYq-TtTOh-ffqlzpfd-RzdObcqAdvK5HoqtR4lCP6t_d6PhdjNkOt8Em6iZZtUyVbqyuimSMI4bm-9htTzEgVxOv9-jxwAW-7cjQcLIpZ7llJ-SZ"/><span class="font-title-md text-title-md text-on-surface ml-xs">Inicio</span></div><div class="w-10 h-10 rounded-full overflow-hidden border-2 border-primary-fixed shadow-sm"><img alt="Carlos Mendoza" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA1bpQ8CvrnwMW1Ur-a_Utfg9oTtIwxTNCIw-5geC56wEJBWXTXgVqNGrHqRv4JwxKBaWJBZ2qMPQH_TmpvjD49TngyZKOSE9Iaq06jx2kSUXxlF9aeFu-5uZW4Uw59uj5FppwEWLo3cL64W5XCBqx7_isfunyqTzDnkwCoGgAIXVgLBVI9Dk4diAwQr62WyliRw2y3v3ht7mb1ptM409WgGK4VxqfR7BTFE4xCY0JK3sQPxB9oLEecDw"/></div></div></header><div class="fixed inset-0 z-[60] -translate-x-full sidebar-transition" id="side-nav"><div class="absolute inset-0 bg-on-surface/40" onclick="this.parentElement.classList.add('-translate-x-full')"></div><nav class="relative w-[280px] h-full bg-surface-container-lowest flex flex-col shadow-xl" data-active-classes="bg-secondary-container text-on-secondary-container"><div class="p-lg bg-primary-container text-on-primary pt-xl border-b border-primary/20"><div class="w-16 h-16 rounded-full border-2 border-primary-fixed shadow-md overflow-hidden mb-md"><img alt="Carlos Mendoza" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA1bpQ8CvrnwMW1Ur-a_Utfg9oTtIwxTNCIw-5geC56wEJBWXTXgVqNGrHqRv4JwxKBaWJBZ2qMPQH_TmpvjD49TngyZKOSE9Iaq06jx2kSUXxlF9aeFu-5uZW4Uw59uj5FppwEWLo3cL64W5XCBqx7_isfunyqTzDnkwCoGgAIXVgLBVI9Dk4diAwQr62WyliRw2y3v3ht7mb1ptM409WgGK4VxqfR7BTFE4xCY0JK3sQPxB9oLEecDw"/></div><div class="font-title-md text-title-md leading-tight">Carlos Mendoza</div><div class="font-label-sm text-label-sm opacity-80 uppercase tracking-wider mt-xs">Supervisor de Campo</div></div><div class="flex-1 py-md overflow-y-auto"><a aria-current="page" class="flex items-center gap-md px-lg py-md transition-colors bg-secondary-container text-on-secondary-container" data-path="inicio" href="#"><span class="material-symbols-outlined">dashboard</span><span class="font-label-md text-label-md">Inicio</span></a><a class="flex items-center gap-md px-lg py-md text-on-surface-variant hover:bg-surface-container-low transition-colors" data-path="tareo-de-campo" href="#"><span class="material-symbols-outlined">assignment</span><span class="font-label-md text-label-md">Tareo de Campo</span></a><a class="flex items-center gap-md px-lg py-md text-on-surface-variant hover:bg-surface-container-low transition-colors" data-path="personal" href="#"><span class="material-symbols-outlined">groups</span><span class="font-label-md text-label-md">Personal</span></a><a class="flex items-center gap-md px-lg py-md text-on-surface-variant hover:bg-surface-container-low transition-colors" data-path="asistencia" href="#"><span class="material-symbols-outlined">how_to_reg</span><span class="font-label-md text-label-md">Asistencia</span></a><a class="flex items-center gap-md px-lg py-md text-on-surface-variant hover:bg-surface-container-low transition-colors" data-path="reportes-de-cosecha" href="#"><span class="material-symbols-outlined">bar_chart</span><span class="font-label-md text-label-md">Reportes de Cosecha</span></a><div class="h-[1px] bg-outline-variant my-sm mx-lg"></div><a class="flex items-center gap-md px-lg py-md text-on-surface-variant hover:bg-surface-container-low transition-colors" data-path="configuracion" href="#"><span class="material-symbols-outlined">settings</span><span class="font-label-md text-label-md">Configuración</span></a></div><div class="p-lg border-t border-outline-variant"><button class="flex items-center gap-md w-full px-md py-sm text-error rounded-lg active:bg-error-container/20 transition-colors"><span class="material-symbols-outlined">logout</span><span class="font-label-md text-label-md">Cerrar Sesión</span></button></div></nav></div><main class="flex flex-col relative w-full pt-16 min-h-screen bg-background"><div class="flex flex-col w-full px-margin-mobile py-lg gap-lg"><div class="flex items-center justify-between"><div><h1 class="font-headline-lg-mobile text-headline-lg-mobile text-on-surface">Hola, Carlos</h1><p class="font-body-md text-body-md text-on-surface-variant">Resumen de hoy</p></div></div><div class="grid grid-cols-2 gap-md"><div class="bg-surface-container-lowest p-md rounded-xl shadow-sm border border-outline-variant flex flex-col gap-sm"><div class="flex items-center gap-xs text-primary"><span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">groups</span><span class="font-label-sm text-label-sm">Personal Activo</span></div><div class="font-display-lg text-display-lg text-on-surface">42</div></div><div class="bg-surface-container-lowest p-md rounded-xl shadow-sm border border-outline-variant flex flex-col gap-sm"><div class="flex items-center gap-xs text-secondary"><span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">grass</span><span class="font-label-sm text-label-sm">Hectáreas</span></div><div class="font-display-lg text-display-lg text-on-surface">15.5</div></div></div><div class="bg-primary-container rounded-xl p-md shadow-md flex items-center justify-between"><div class="flex flex-col gap-xs"><span class="font-label-md text-label-md text-on-primary-container">Rendimiento Promedio</span><div class="font-headline-lg-mobile text-headline-lg-mobile text-on-primary">85%</div></div><div class="relative w-16 h-16 flex items-center justify-center"><svg class="absolute inset-0 w-full h-full transform -rotate-90" viewbox="0 0 36 36"><path class="text-on-primary-container/30" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="currentColor" stroke-dasharray="100, 100" stroke-width="3"></path><path class="text-secondary-container" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" fill="none" stroke="currentColor" stroke-dasharray="85, 100" stroke-width="3"></path></svg><span class="material-symbols-outlined text-secondary-container" style="font-variation-settings: 'FILL' 1;">trending_up</span></div></div><div class="flex flex-col gap-md"><h2 class="font-title-md text-title-md text-on-surface">Tareas del Día</h2><div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-md flex flex-col gap-sm relative overflow-hidden"><div class="flex items-center justify-between z-10 relative"><div><h3 class="font-label-md text-label-md text-on-surface">Cosecha Sector Norte</h3><p class="font-label-sm text-label-sm text-on-surface-variant">Lote 4A • 12 trabajadores</p></div><div class="bg-secondary-container/20 text-on-secondary-container px-2 py-1 rounded-md font-label-sm text-label-sm">En curso</div></div><div class="w-full bg-surface-container-high h-2 rounded-full overflow-hidden z-10 relative mt-2"><div class="bg-secondary h-full w-[65%] rounded-full"></div></div></div><div class="bg-surface-container-lowest rounded-xl shadow-sm border border-outline-variant p-md flex flex-col gap-sm relative overflow-hidden"><div class="flex items-center justify-between z-10 relative"><div><h3 class="font-label-md text-label-md text-on-surface">Poda Sector Sur</h3><p class="font-label-sm text-label-sm text-on-surface-variant">Lote 2B • 8 trabajadores</p></div><div class="bg-tertiary-container/10 text-on-tertiary-container px-2 py-1 rounded-md font-label-sm text-label-sm">Planificada</div></div><div class="w-full bg-surface-container-high h-2 rounded-full overflow-hidden z-10 relative mt-2"><div class="bg-outline h-full w-[10%] rounded-full"></div></div></div></div><div class="flex gap-md mt-md pb-safe"><button class="flex-1 bg-primary text-on-primary h-14 rounded-xl flex items-center justify-center gap-xs font-label-md text-label-md shadow-md active:translate-y-px transition-transform"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">add_task</span>Nuevo Tareo</button><button class="flex-1 bg-surface-container-lowest border-2 border-primary text-primary h-14 rounded-xl flex items-center justify-center gap-xs font-label-md text-label-md shadow-sm active:bg-surface-container-low transition-colors"><span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">how_to_reg</span>Asistencia</button></div></div></main></body></html>
<!DOCTYPE html>

<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        "colors": {
                "on-tertiary-fixed-variant": "#643e24",
                "secondary": "#006c48",
                "secondary-container": "#92f7c3",
                "on-error": "#ffffff",
                "surface-container-highest": "#e1e3e4",
                "on-tertiary-fixed": "#301401",
                "primary-container": "#1b4332",
                "on-error-container": "#93000a",
                "on-primary-fixed-variant": "#274e3d",
                "background": "#f8f9fa",
                "on-primary": "#ffffff",
                "surface-variant": "#e1e3e4",
                "on-tertiary": "#ffffff",
                "outline-variant": "#c1c8c2",
                "on-secondary-fixed-variant": "#005235",
                "on-surface": "#191c1d",
                "secondary-fixed-dim": "#75daa8",
                "surface-dim": "#d9dadb",
                "tertiary": "#3d1e07",
                "inverse-primary": "#a5d0b9",
                "surface-bright": "#f8f9fa",
                "tertiary-fixed-dim": "#f2bb98",
                "surface-container-lowest": "#ffffff",
                "primary": "#012d1d",
                "surface-tint": "#3f6653",
                "tertiary-fixed": "#ffdcc7",
                "outline": "#717973",
                "inverse-surface": "#2e3132",
                "on-primary-fixed": "#002114",
                "error-container": "#ffdad6",
                "surface": "#f8f9fa",
                "on-background": "#191c1d",
                "secondary-fixed": "#92f7c3",
                "on-secondary-container": "#00734d",
                "primary-fixed-dim": "#a5d0b9",
                "surface-container-low": "#f3f4f5",
                "on-surface-variant": "#414844",
                "error": "#ba1a1a",
                "inverse-on-surface": "#f0f1f2",
                "primary-fixed": "#c1ecd4",
                "surface-container-high": "#e7e8e9",
                "tertiary-container": "#57331a",
                "on-tertiary-container": "#cf9b7a",
                "on-secondary-fixed": "#002113",
                "surface-container": "#edeeef",
                "on-primary-container": "#86af99",
                "on-secondary": "#ffffff"
        },
        "borderRadius": {
                "DEFAULT": "0.25rem",
                "lg": "0.5rem",
                "xl": "0.75rem",
                "full": "9999px"
        },
        "spacing": {
                "margin-mobile": "16px",
                "lg": "24px",
                "sm": "12px",
                "xs": "4px",
                "xl": "40px",
                "md": "16px",
                "base": "8px",
                "gutter": "16px",
                "margin-desktop": "32px"
        },
        "fontFamily": {
                "headline-lg": [
                        "Inter"
                ],
                "label-md": [
                        "Inter"
                ],
                "headline-lg-mobile": [
                        "Inter"
                ],
                "body-md": [
                        "Inter"
                ],
                "body-lg": [
                        "Inter"
                ],
                "title-md": [
                        "Inter"
                ],
                "display-lg": [
                        "Inter"
                ],
                "label-sm": [
                        "Inter"
                ]
        },
        "fontSize": {
                "headline-lg": [
                        "32px",
                        {
                                "lineHeight": "40px",
                                "fontWeight": "600"
                        }
                ],
                "label-md": [
                        "14px",
                        {
                                "lineHeight": "20px",
                                "letterSpacing": "0.01em",
                                "fontWeight": "500"
                        }
                ],
                "headline-lg-mobile": [
                        "24px",
                        {
                                "lineHeight": "32px",
                                "fontWeight": "600"
                        }
                ],
                "body-md": [
                        "16px",
                        {
                                "lineHeight": "24px",
                                "fontWeight": "400"
                        }
                ],
                "body-lg": [
                        "18px",
                        {
                                "lineHeight": "28px",
                                "fontWeight": "400"
                        }
                ],
                "title-md": [
                        "20px",
                        {
                                "lineHeight": "28px",
                                "fontWeight": "600"
                        }
                ],
                "display-lg": [
                        "48px",
                        {
                                "lineHeight": "56px",
                                "letterSpacing": "-0.02em",
                                "fontWeight": "700"
                        }
                ],
                "label-sm": [
                        "12px",
                        {
                                "lineHeight": "16px",
                                "letterSpacing": "0.05em",
                                "fontWeight": "600"
                        }
                ]
        }
},
    },
  }
</script><style>@layer base { body { -webkit-tap-highlight-color: transparent; overscroll-behavior-y: contain; } .pt-safe { padding-top: env(safe-area-inset-top, 0px); } .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0px); } } .sidebar-transition { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }</style></head><body class="bg-background font-body-md text-on-background transition-all"><header class="fixed top-0 w-full z-50 bg-surface/80 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] pt-safe"><div class="h-16 px-margin-mobile flex items-center justify-between"><div class="flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full active:bg-surface-container-high" onclick="document.getElementById('side-nav').classList.remove('-translate-x-full')"><span class="material-symbols-outlined text-on-surface">menu</span></button><img alt="Logo" class="h-8 w-auto object-contain" src="https://lh3.googleusercontent.com/aida/AP1WRLvzrrQ44Q7SKTpREEJaFwcaBJ2_fBqfNQLCtbFCkDcQfKbdqEpLqrtZyyxri5IaN9RFr0wlbyOe-DXSJTClDjo3dViJZ-LrtibMw-B0Y9tsOOA0mXcCZzbEhlogoO1A1QtD_cbixHoCMYq-TtTOh-ffqlzpfd-RzdObcqAdvK5HoqtR4lCP6t_d6PhdjNkOt8Em6iZZtUyVbqyuimSMI4bm-9htTzEgVxOv9-jxwAW-7cjQcLIpZ7llJ-SZ"/><span class="font-title-md text-title-md text-on-surface ml-xs">Inicio</span></div><div class="w-10 h-10 rounded-full overflow-hidden border-2 border-primary-fixed shadow-sm"><img alt="Carlos Mendoza" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida/AP1WRLs80D1ZPCg3qZRfFQHVDk5N1QrKLl6EpEtTsDW592JGITUkqlD1yRPCBX6tvCSXu3NmzAZnJ7WSR7WhIX_KeOeO3eG4BQG4_CMgOIkh6XU_-rijBHdJVOa4uvLqnoPFygSDntSYTPWkZpS_zF3xUTZ8K4OhKsoXfOCF8EivHwqgg41QATNrCzDS-WWBF6YyU2Ojw1F1AyWgyFGbO64UtufuT6udUK8H28Qdoa_Pi_Xk3VIoavMXuCbZzEN5"/></div></div></header><main class="flex flex-col relative w-full pt-16 min-h-screen bg-background"><div class="fixed inset-0 z-[60] flex flex-col w-full h-full font-body-md sidebar-transition" id="side-nav">
<!-- Backdrop Overlay (Simulating sidebar opening over screen 2) -->
<div class="absolute inset-0 bg-on-surface/40 backdrop-blur-sm transition-opacity" onclick="document.getElementById('side-nav').classList.add('-translate-x-full')" style="z-index: -1;">
<!-- Injecting underlying dashboard view to simulate open state -->
<iframe class="w-full h-full border-none opacity-50 pointer-events-none" src="{{DATA:SCREEN:SCREEN_2}}"></iframe>
</div>
<!-- Sidebar Container -->
<aside class="w-[85%] max-w-[320px] h-full bg-surface shadow-2xl flex flex-col overflow-hidden animate-[slideRight_0.3s_ease-out]">
<!-- Header / Profile Section -->
<div class="bg-primary-container text-on-primary p-lg pt-xl flex flex-col items-start shadow-md relative overflow-hidden">
<!-- Decorative background element -->
<div class="absolute -top-12 -right-12 w-40 h-40 bg-primary/30 rounded-full blur-2xl"></div>
<div class="w-20 h-20 rounded-full bg-surface-container-highest shadow-inner overflow-hidden mb-sm relative z-10 border-2 border-primary-fixed">
<img alt="Carlos Mendoza - Profile Picture" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida/AP1WRLs80D1ZPCg3qZRfFQHVDk5N1QrKLl6EpEtTsDW592JGITUkqlD1yRPCBX6tvCSXu3NmzAZnJ7WSR7WhIX_KeOeO3eG4BQG4_CMgOIkh6XU_-rijBHdJVOa4uvLqnoPFygSDntSYTPWkZpS_zF3xUTZ8K4OhKsoXfOCF8EivHwqgg41QATNrCzDS-WWBF6YyU2Ojw1F1AyWgyFGbO64UtufuT6udUK8H28Qdoa_Pi_Xk3VIoavMXuCbZzEN5"/>
</div>
<h2 class="font-title-md text-title-md relative z-10">Carlos Mendoza</h2>
<p class="font-label-sm text-label-sm text-primary-fixed uppercase tracking-wider mt-xs relative z-10">Supervisor Agrícola</p>
<!-- Close Button (Mobile typical) -->
<button class="absolute top-md right-md w-10 h-10 flex items-center justify-center rounded-full bg-on-primary/10 hover:bg-on-primary/20 text-on-primary transition-colors z-10 active:scale-95" onclick="document.getElementById('side-nav').classList.add('-translate-x-full')">
<span class="material-symbols-outlined text-[24px]">close</span>
</button>
</div>
<!-- Navigation Links -->
<nav class="flex-1 overflow-y-auto py-sm">
<ul class="flex flex-col gap-xs px-sm">
<!-- Active Link -->
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg bg-secondary-container text-on-secondary-container font-label-md text-label-md transition-colors shadow-sm" href="#">
<span class="material-symbols-outlined text-[24px]" style="font-variation-settings: 'FILL' 1;">dashboard</span>
                        Inicio
                    </a>
</li>
<!-- Default Links -->
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg text-on-surface hover:bg-surface-container-low active:bg-surface-container font-body-md text-body-md transition-colors" href="#">
<span class="material-symbols-outlined text-[24px] text-on-surface-variant">edit_document</span>
                        Tareo
                    </a>
</li>
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg text-on-surface hover:bg-surface-container-low active:bg-surface-container font-body-md text-body-md transition-colors" href="#">
<span class="material-symbols-outlined text-[24px] text-on-surface-variant">groups</span>
                        Personal
                    </a>
</li>
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg text-on-surface hover:bg-surface-container-low active:bg-surface-container font-body-md text-body-md transition-colors" href="#">
<span class="material-symbols-outlined text-[24px] text-on-surface-variant">trending_up</span>
                        Productividad
                    </a>
</li>
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg text-on-surface hover:bg-surface-container-low active:bg-surface-container font-body-md text-body-md transition-colors" href="#">
<span class="material-symbols-outlined text-[24px] text-on-surface-variant">bar_chart</span>
                        Resumen
                    </a>
</li>
<li class="mt-xs mb-xs px-md">
<div class="h-[1px] bg-outline-variant/30 w-full"></div>
</li>
<li>
<a class="flex items-center gap-md px-md py-sm rounded-lg text-on-surface hover:bg-surface-container-low active:bg-surface-container font-body-md text-body-md transition-colors" href="#">
<span class="material-symbols-outlined text-[24px] text-on-surface-variant">settings</span>
                        Configuración
                    </a>
</li>
</ul>
</nav>
<!-- Footer / Logout -->
<div class="p-md pb-xl shadow-[0_-4px_16px_rgba(0,0,0,0.02)] bg-surface mt-auto">
<button class="w-full flex items-center justify-center gap-sm py-sm px-md rounded-lg text-error hover:bg-error-container/50 active:bg-error-container transition-colors font-label-md text-label-md">
<span class="material-symbols-outlined text-[24px]">logout</span>
                Cerrar Sesión
            </button>
</div>
</aside>
<style>
        @keyframes slideRight {
            from { transform: translateX(-100%); }
            to { transform: translateX(0); }
        }
    </style>
</div><div class="h-20"></div></main><nav class="fixed bottom-0 w-full z-40 bg-surface/90 backdrop-blur-xl shadow-[0_-1px_8px_rgba(0,0,0,0.04)] pb-safe" data-active-classes="text-secondary"><div class="flex justify-around items-center h-16"><a aria-current="page" class="flex flex-col items-center justify-center gap-xs w-16 h-14 transition-all active:scale-95 text-secondary" data-path="inicio" href="#"><span class="material-symbols-outlined text-[24px]">home</span><span class="font-label-sm text-label-sm">Inicio</span></a><a class="flex flex-col items-center justify-center gap-xs w-16 h-14 text-on-surface-variant transition-all active:scale-95" data-path="tareo" href="#"><span class="material-symbols-outlined text-[24px]">task_alt</span><span class="font-label-sm text-label-sm">Tareo</span></a><a class="flex flex-col items-center justify-center gap-xs w-16 h-14 text-on-surface-variant transition-all active:scale-95" data-path="personal" href="#"><span class="material-symbols-outlined text-[24px]">groups</span><span class="font-label-sm text-label-sm">Personal</span></a><a class="flex flex-col items-center justify-center gap-xs w-16 h-14 text-on-surface-variant transition-all active:scale-95" data-path="configuracion" href="#"><span class="material-symbols-outlined text-[24px]">person</span><span class="font-label-sm text-label-sm">Perfil</span></a></div></nav></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "tertiary-fixed-dim": "#f2bb98", "secondary-fixed-dim": "#75daa8", "on-tertiary-container": "#cf9b7a", "on-secondary-fixed-variant": "#005235", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "tertiary": "#3d1e07", "primary": "#012d1d", "surface-dim": "#d9dadb", "surface-tint": "#3f6653", "on-primary-container": "#86af99", "inverse-on-surface": "#f0f1f2", "on-primary-fixed-variant": "#274e3d", "on-surface": "#191c1d", "tertiary-container": "#57331a", "surface-container-lowest": "#ffffff", "secondary-fixed": "#92f7c3", "error": "#ba1a1a", "inverse-primary": "#a5d0b9", "surface-container-low": "#f3f4f5", "on-secondary": "#ffffff", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "surface": "#f8f9fa", "background": "#f8f9fa", "primary-container": "#1b4332", "on-error-container": "#93000a", "surface-bright": "#f8f9fa", "primary-fixed": "#c1ecd4", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "secondary": "#006c48", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "tertiary-fixed": "#ffdcc7", "outline": "#717973", "on-secondary-container": "#00734d", "surface-container-highest": "#e1e3e4", "surface-container": "#edeeef", "on-secondary-fixed": "#002113", "error-container": "#ffdad6", "on-background": "#191c1d", "secondary-container": "#92f7c3", "on-primary": "#ffffff", "on-error": "#ffffff", "on-tertiary-fixed": "#301401" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "lg": "24px", "gutter": "16px", "margin-desktop": "32px", "base": "8px", "xl": "40px", "xs": "4px", "sm": "12px", "margin-mobile": "16px", "md": "16px" }, "fontFamily": { "body-md": ["Inter"], "body-lg": ["Inter"], "headline-lg-mobile": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "title-md": ["Inter"], "display-lg": ["Inter"], "label-sm": ["Inter"] } } } }</script><style>@layer base { .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0); } .pt-safe { padding-top: env(safe-area-inset-top, 0); } } </style><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background text-on-surface font-body-md overflow-x-hidden pt-safe pb-safe"><main class="min-h-screen w-full relative flex flex-col"><div class="flex flex-col w-full h-full relative bg-surface-container-lowest">
<!-- Header Area -->
<header class="bg-primary text-on-primary rounded-b-[32px] pt-4 pb-6 px-4 shadow-lg flex-shrink-0 z-10 relative overflow-hidden">
<div class="absolute inset-0 opacity-10 pointer-events-none">
<svg height="100%" width="100%" xmlns="http://www.w3.org/2000/svg">
<defs>
<pattern height="40" id="leaf-pattern" patternunits="userSpaceOnUse" width="40" x="0" y="0">
<path d="M20 5 Q 30 10, 35 20 Q 25 30, 20 35 Q 10 30, 5 20 Q 10 10, 20 5 Z" fill="currentColor" fill-opacity="0.3"></path>
</pattern>
</defs>
<rect fill="url(#leaf-pattern)" height="100%" width="100%"></rect>
</svg>
</div>
<div class="flex items-center justify-between mb-6 relative z-10">
<h1 class="text-headline-lg-mobile font-headline-lg-mobile tracking-tight">Tareo</h1>
<div class="flex gap-3">
<button class="w-10 h-10 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center hover:bg-surface-tint hover:text-on-primary transition-colors active:scale-95 shadow-sm">
<span class="material-symbols-outlined text-[20px]">filter_list</span>
</button>
<button class="w-10 h-10 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center hover:bg-surface-tint hover:text-on-primary transition-colors active:scale-95 shadow-sm relative">
<span class="material-symbols-outlined text-[20px]">qr_code_scanner</span>
<span class="absolute top-1 right-1 w-2 h-2 bg-secondary-fixed rounded-full shadow-[0_0_8px_rgba(146,247,195,0.8)]"></span>
</button>
</div>
</div>
<!-- Search Fields (Bento style) -->
<div class="grid gap-3 relative z-10">
<div class="bg-surface-container-lowest text-on-surface rounded-xl flex items-center p-1 pl-4 shadow-sm relative overflow-hidden group focus-within:ring-2 focus-within:ring-secondary-fixed/50">
<span class="material-symbols-outlined text-outline mr-2 transition-colors group-focus-within:text-primary">location_on</span>
<input class="w-full bg-transparent text-body-md font-body-md text-on-surface placeholder:text-outline/70 focus:outline-none py-2" placeholder="Ubicación (Ej. P124 - Llano)" type="text" value="P124 - Sector Norte"/>
<button class="w-10 h-10 flex items-center justify-center text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined text-[18px]">close</span>
</button>
</div>
<div class="bg-surface-container-lowest text-on-surface rounded-xl flex items-center p-1 pl-4 shadow-sm relative overflow-hidden group focus-within:ring-2 focus-within:ring-secondary-fixed/50">
<span class="material-symbols-outlined text-outline mr-2 transition-colors group-focus-within:text-primary">assignment</span>
<input class="w-full bg-transparent text-body-md font-body-md text-on-surface placeholder:text-outline/70 focus:outline-none py-2" placeholder="Actividad / Tareo" type="text" value="Cosecha de Arándanos"/>
<button class="w-10 h-10 flex items-center justify-center text-outline hover:text-primary transition-colors">
<span class="material-symbols-outlined text-[18px]">close</span>
</button>
</div>
</div>
<!-- Status Bar -->
<div class="mt-4 flex items-center justify-between text-label-sm font-label-sm text-primary-fixed-dim relative z-10">
<div class="flex items-center gap-1">
<span class="w-2 h-2 rounded-full bg-secondary-fixed animate-pulse"></span>
<span>Sincronizado hace 2 min</span>
</div>
<div class="flex items-center gap-1 bg-primary-container px-2 py-1 rounded-md text-on-primary-container">
<span class="material-symbols-outlined text-[14px]">groups</span>
<span>24 / 30</span>
</div>
</div>
</header>
<!-- List Area -->
<main class="flex-1 overflow-y-auto px-4 pt-4 pb-24 bg-surface flex flex-col gap-3 relative" id="worker-list-container">
<!-- Worker Card 1 - Scanned -->
<div class="bg-surface-container-lowest rounded-2xl p-4 shadow-sm relative overflow-hidden transition-all duration-300 transform hover:-translate-y-1 group">
<div class="absolute left-0 top-0 bottom-0 w-1.5 bg-secondary"></div>
<div class="flex items-center justify-between">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex flex-shrink-0 items-center justify-center text-title-md font-title-md text-primary relative">
                         JC
                         <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-secondary text-on-secondary rounded-full flex items-center justify-center shadow-sm">
<span class="material-symbols-outlined text-[12px]" style="font-variation-settings: 'FILL' 1;">check</span>
</div>
</div>
<div>
<h3 class="text-body-lg font-body-lg text-on-surface font-semibold leading-tight mb-1">Juan Carlos Mendoza</h3>
<div class="flex items-center gap-2 text-label-sm font-label-sm text-on-surface-variant">
<span class="bg-surface-container px-1.5 py-0.5 rounded text-outline-variant">ID: 4589210</span>
<span class="flex items-center gap-0.5 text-secondary"><span class="material-symbols-outlined text-[14px]">schedule</span> 06:45 AM</span>
</div>
</div>
</div>
<button class="w-8 h-8 rounded-full text-outline hover:bg-surface-container hover:text-on-surface flex items-center justify-center transition-colors">
<span class="material-symbols-outlined text-[20px]">more_vert</span>
</button>
</div>
<div class="mt-3 pt-3 border-t border-surface-container-highest flex gap-2 overflow-x-auto pb-1 hide-scrollbar">
<span class="whitespace-nowrap px-2 py-1 bg-tertiary-container/10 text-tertiary-container rounded-md text-label-sm font-label-sm flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]">eco</span>
                    Bandejas: 12
                </span>
</div>
</div>
<!-- Worker Card 2 - Scanned -->
<div class="bg-surface-container-lowest rounded-2xl p-4 shadow-sm relative overflow-hidden transition-all duration-300 transform hover:-translate-y-1 group">
<div class="absolute left-0 top-0 bottom-0 w-1.5 bg-secondary"></div>
<div class="flex items-center justify-between">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex flex-shrink-0 items-center justify-center text-title-md font-title-md text-primary relative">
                         MR
                         <div class="absolute -bottom-1 -right-1 w-5 h-5 bg-secondary text-on-secondary rounded-full flex items-center justify-center shadow-sm">
<span class="material-symbols-outlined text-[12px]" style="font-variation-settings: 'FILL' 1;">check</span>
</div>
</div>
<div>
<h3 class="text-body-lg font-body-lg text-on-surface font-semibold leading-tight mb-1">Maria Rojas Villanueva</h3>
<div class="flex items-center gap-2 text-label-sm font-label-sm text-on-surface-variant">
<span class="bg-surface-container px-1.5 py-0.5 rounded text-outline-variant">ID: 4233158</span>
<span class="flex items-center gap-0.5 text-secondary"><span class="material-symbols-outlined text-[14px]">schedule</span> 06:52 AM</span>
</div>
</div>
</div>
<button class="w-8 h-8 rounded-full text-outline hover:bg-surface-container hover:text-on-surface flex items-center justify-center transition-colors">
<span class="material-symbols-outlined text-[20px]">more_vert</span>
</button>
</div>
<div class="mt-3 pt-3 border-t border-surface-container-highest flex gap-2 overflow-x-auto pb-1 hide-scrollbar">
<span class="whitespace-nowrap px-2 py-1 bg-tertiary-container/10 text-tertiary-container rounded-md text-label-sm font-label-sm flex items-center gap-1">
<span class="material-symbols-outlined text-[14px]">eco</span>
                    Bandejas: 15
                </span>
</div>
</div>
<!-- Worker Card 3 - Pending -->
<div class="bg-surface-container-lowest rounded-2xl p-4 shadow-sm relative overflow-hidden transition-all duration-300 transform hover:-translate-y-1 group">
<div class="absolute left-0 top-0 bottom-0 w-1.5 bg-outline-variant"></div>
<div class="flex items-center justify-between opacity-80">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex flex-shrink-0 items-center justify-center text-title-md font-title-md text-outline-variant relative">
                         LP
                     </div>
<div>
<h3 class="text-body-lg font-body-lg text-on-surface font-semibold leading-tight mb-1">Luis Perez</h3>
<div class="flex items-center gap-2 text-label-sm font-label-sm text-on-surface-variant">
<span class="bg-surface-container px-1.5 py-0.5 rounded text-outline-variant">ID: 4899201</span>
<span class="flex items-center gap-0.5 text-outline"><span class="material-symbols-outlined text-[14px]">pending</span> Pendiente</span>
</div>
</div>
</div>
<button class="w-10 h-10 rounded-full bg-primary/10 text-primary hover:bg-primary hover:text-on-primary flex items-center justify-center transition-colors shadow-sm">
<span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">qr_code</span>
</button>
</div>
</div>
<!-- Worker Card 4 - Pending -->
<div class="bg-surface-container-lowest rounded-2xl p-4 shadow-sm relative overflow-hidden transition-all duration-300 transform hover:-translate-y-1 group">
<div class="absolute left-0 top-0 bottom-0 w-1.5 bg-outline-variant"></div>
<div class="flex items-center justify-between opacity-80">
<div class="flex items-center gap-4">
<div class="w-12 h-12 rounded-full bg-surface-container-high flex flex-shrink-0 items-center justify-center text-title-md font-title-md text-outline-variant relative">
                         CQ
                     </div>
<div>
<h3 class="text-body-lg font-body-lg text-on-surface font-semibold leading-tight mb-1">Carmen Quispe</h3>
<div class="flex items-center gap-2 text-label-sm font-label-sm text-on-surface-variant">
<span class="bg-surface-container px-1.5 py-0.5 rounded text-outline-variant">ID: 4122905</span>
<span class="flex items-center gap-0.5 text-outline"><span class="material-symbols-outlined text-[14px]">pending</span> Pendiente</span>
</div>
</div>
</div>
<button class="w-10 h-10 rounded-full bg-primary/10 text-primary hover:bg-primary hover:text-on-primary flex items-center justify-center transition-colors shadow-sm">
<span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">qr_code</span>
</button>
</div>
</div>
</main>
<!-- FAB for Quick Add (Manual Entry) -->
<button aria-label="Añadir trabajador manual" class="absolute bottom-24 right-4 w-14 h-14 bg-secondary-fixed text-on-secondary-fixed rounded-2xl flex items-center justify-center shadow-lg hover:shadow-xl transition-all active:scale-95 z-20">
<span class="material-symbols-outlined text-[28px]">person_add</span>
</button>
<!-- Bottom Navigation Bar -->
<nav class="fixed bottom-0 left-0 right-0 h-20 bg-surface-container-lowest flex items-center justify-around shadow-[0_-4px_20px_rgba(0,0,0,0.05)] px-2 pb-safe z-30">
<!-- Tab 1: Tareo (Active) -->
<button class="flex flex-col items-center justify-center w-full h-full gap-1 text-primary relative group">
<div class="absolute -top-1 w-12 h-1 bg-primary rounded-b-full"></div>
<div class="w-16 h-8 rounded-full bg-primary-container/20 flex items-center justify-center transition-colors">
<span class="material-symbols-outlined text-[24px]" style="font-variation-settings: 'FILL' 1;">how_to_reg</span>
</div>
<span class="text-label-sm font-label-sm font-bold">Tareo</span>
</button>
<!-- Tab 2: Productividad -->
<button class="flex flex-col items-center justify-center w-full h-full gap-1 text-on-surface-variant hover:text-primary transition-colors group">
<div class="w-16 h-8 rounded-full group-hover:bg-surface-container-high flex items-center justify-center transition-colors">
<span class="material-symbols-outlined text-[24px]">monitoring</span>
</div>
<span class="text-label-sm font-label-sm">Productividad</span>
</button>
<!-- Tab 3: Resumen -->
<button class="flex flex-col items-center justify-center w-full h-full gap-1 text-on-surface-variant hover:text-primary transition-colors group">
<div class="w-16 h-8 rounded-full group-hover:bg-surface-container-high flex items-center justify-center transition-colors">
<span class="material-symbols-outlined text-[24px]">assignment</span>
</div>
<span class="text-label-sm font-label-sm">Resumen</span>
</button>
</nav>
<style>
        .hide-scrollbar::-webkit-scrollbar {
            display: none;
        }
        .hide-scrollbar {
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
    </style>
</div></main></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "tertiary-fixed-dim": "#f2bb98", "secondary-fixed-dim": "#75daa8", "on-tertiary-container": "#cf9b7a", "on-secondary-fixed-variant": "#005235", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "tertiary": "#3d1e07", "primary": "#012d1d", "surface-dim": "#d9dadb", "surface-tint": "#3f6653", "on-primary-container": "#86af99", "inverse-on-surface": "#f0f1f2", "on-primary-fixed-variant": "#274e3d", "on-surface": "#191c1d", "tertiary-container": "#57331a", "surface-container-lowest": "#ffffff", "secondary-fixed": "#92f7c3", "error": "#ba1a1a", "inverse-primary": "#a5d0b9", "surface-container-low": "#f3f4f5", "on-secondary": "#ffffff", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "surface": "#f8f9fa", "background": "#f8f9fa", "primary-container": "#1b4332", "on-error-container": "#93000a", "surface-bright": "#f8f9fa", "primary-fixed": "#c1ecd4", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "secondary": "#006c48", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "tertiary-fixed": "#ffdcc7", "outline": "#717973", "on-secondary-container": "#00734d", "surface-container-highest": "#e1e3e4", "surface-container": "#edeeef", "on-secondary-fixed": "#002113", "error-container": "#ffdad6", "on-background": "#191c1d", "secondary-container": "#92f7c3", "on-primary": "#ffffff", "on-error": "#ffffff", "on-tertiary-fixed": "#301401" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "lg": "24px", "gutter": "16px", "margin-desktop": "32px", "base": "8px", "xl": "40px", "xs": "4px", "sm": "12px", "margin-mobile": "16px", "md": "16px" }, "fontFamily": { "body-md": ["Inter"], "body-lg": ["Inter"], "headline-lg-mobile": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "title-md": ["Inter"], "display-lg": ["Inter"], "label-sm": ["Inter"] } } } }</script><style>@layer base { .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0); } .pt-safe { padding-top: env(safe-area-inset-top, 0); } } </style><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background text-on-surface font-body-md overflow-x-hidden pt-safe pb-safe"><main class="min-h-screen w-full relative flex flex-col"><div class="flex flex-col w-full bg-background min-h-full">
<!-- Header Section -->
<header class="bg-primary text-on-primary sticky top-0 z-20 shadow-md">
<div class="flex items-center justify-between px-4 py-3">
<div class="flex items-center gap-3">
<button aria-label="Menu" class="p-2 rounded-full hover:bg-white/10 transition-colors">
<span class="material-symbols-outlined">menu</span>
</button>
<div>
<h1 class="font-title-md text-on-primary">Sin Grupo</h1>
<p class="font-label-sm text-primary-fixed-dim">Gestión de Personal</p>
</div>
</div>
<div class="flex items-center gap-2">
<button aria-label="Sync" class="p-2 rounded-full hover:bg-white/10 transition-colors" title="Sync (Online)">
<span class="material-symbols-outlined text-secondary-fixed">cloud_sync</span>
</button>
<button aria-label="Pause All" class="p-2 rounded-full hover:bg-white/10 transition-colors">
<span class="material-symbols-outlined">pause_circle</span>
</button>
<button aria-label="Add Worker" class="p-2 rounded-full hover:bg-white/10 transition-colors bg-secondary text-on-secondary shadow-sm">
<span class="material-symbols-outlined">person_add</span>
</button>
</div>
</div>
<!-- Navigation Tabs -->
<div class="flex overflow-x-auto hide-scrollbar px-2 pb-0">
<button class="flex-shrink-0 px-4 py-3 relative font-label-md text-on-primary transition-colors">
<div class="flex items-center gap-2">
<span>Personal</span>
<span class="bg-primary-fixed text-on-primary-fixed px-1.5 py-0.5 rounded-full text-[10px] font-bold">12</span>
</div>
<div class="absolute bottom-0 left-0 w-full h-1 bg-secondary-fixed rounded-t-full"></div>
</button>
<button class="flex-shrink-0 px-4 py-3 font-label-md text-primary-fixed-dim hover:text-on-primary transition-colors">
        Productividad
      </button>
<button class="flex-shrink-0 px-4 py-3 font-label-md text-primary-fixed-dim hover:text-on-primary transition-colors">
        Stock cajas
      </button>
<button class="flex-shrink-0 px-4 py-3 font-label-md text-primary-fixed-dim hover:text-on-primary transition-colors">
        Entregas
      </button>
</div>
</header>
<!-- Content Section -->
<main class="flex-1 overflow-y-auto bg-surface-container-low p-2 space-y-3 pb-24">
<!-- Group 1 -->
<div class="bg-surface rounded-xl shadow-sm overflow-hidden flex flex-col group-accordion">
<button class="flex items-center justify-between w-full p-3 bg-tertiary-container text-on-tertiary-container transition-colors accordion-toggle">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-tertiary-fixed-dim" style="font-variation-settings: 'FILL' 1;">eco</span>
<span class="font-label-md font-bold uppercase tracking-wider">VID-SUPERVISOR DESBROTE</span>
</div>
<div class="flex items-center gap-3">
<span class="bg-tertiary-fixed text-on-tertiary-fixed px-2 py-0.5 rounded-md font-label-sm">4</span>
<span class="material-symbols-outlined transition-transform duration-300 rotate-180 icon-chevron">expand_more</span>
</div>
</button>
<div class="accordion-content bg-surface flex flex-col">
<!-- Worker List Item -->
<label class="flex items-center p-3 gap-3 hover:bg-surface-container-highest transition-colors cursor-pointer border-b border-surface-container border-opacity-50">
<div class="relative flex items-center">
<input checked="" class="w-6 h-6 rounded border-outline text-primary focus:ring-primary focus:ring-offset-surface peer cursor-pointer" type="checkbox"/>
</div>
<div class="w-10 h-10 rounded-full bg-surface-container-high flex items-center justify-center text-on-surface-variant font-title-md shrink-0">
            J
          </div>
<div class="flex-1 min-w-0">
<div class="font-body-md text-on-surface font-medium truncate">Juan Carlos Perez Gomez</div>
<div class="font-label-sm text-on-surface-variant flex items-center gap-2">
<span class="material-symbols-outlined text-[14px]">badge</span> 45321890
            </div>
</div>
<div class="flex flex-col items-end shrink-0">
<span class="bg-secondary-container text-on-secondary-container px-2 py-1 rounded-md font-label-sm flex items-center gap-1">
<span class="material-symbols-outlined text-[12px]">schedule</span> 07:30
            </span>
</div>
</label>
<label class="flex items-center p-3 gap-3 hover:bg-surface-container-highest transition-colors cursor-pointer border-b border-surface-container border-opacity-50">
<div class="relative flex items-center">
<input checked="" class="w-6 h-6 rounded border-outline text-primary focus:ring-primary focus:ring-offset-surface peer cursor-pointer" type="checkbox"/>
</div>
<div class="w-10 h-10 rounded-full bg-surface-container-high flex items-center justify-center text-on-surface-variant font-title-md shrink-0">
            M
          </div>
<div class="flex-1 min-w-0">
<div class="font-body-md text-on-surface font-medium truncate">Maria Fernandez Rodriguez</div>
<div class="font-label-sm text-on-surface-variant flex items-center gap-2">
<span class="material-symbols-outlined text-[14px]">badge</span> 42890123
            </div>
</div>
<div class="flex flex-col items-end shrink-0">
<span class="bg-secondary-container text-on-secondary-container px-2 py-1 rounded-md font-label-sm flex items-center gap-1">
<span class="material-symbols-outlined text-[12px]">schedule</span> 07:45
            </span>
</div>
</label>
</div>
</div>
<!-- Group 2 -->
<div class="bg-surface rounded-xl shadow-sm overflow-hidden flex flex-col group-accordion">
<button class="flex items-center justify-between w-full p-3 bg-primary-container text-on-primary-container transition-colors accordion-toggle">
<div class="flex items-center gap-3">
<span class="material-symbols-outlined text-primary-fixed" style="font-variation-settings: 'FILL' 1;">groups</span>
<span class="font-label-md font-bold uppercase tracking-wider">VID-LIDER DESBROTE</span>
</div>
<div class="flex items-center gap-3">
<span class="bg-primary-fixed text-on-primary-fixed px-2 py-0.5 rounded-md font-label-sm">8</span>
<span class="material-symbols-outlined transition-transform duration-300 icon-chevron">expand_more</span>
</div>
</button>
<div class="accordion-content bg-surface flex flex-col hidden">
<label class="flex items-center p-3 gap-3 hover:bg-surface-container-highest transition-colors cursor-pointer border-b border-surface-container border-opacity-50">
<div class="relative flex items-center">
<input class="w-6 h-6 rounded border-outline text-primary focus:ring-primary focus:ring-offset-surface peer cursor-pointer" type="checkbox"/>
</div>
<div class="w-10 h-10 rounded-full bg-surface-container-high flex items-center justify-center text-on-surface-variant font-title-md shrink-0">
            L
          </div>
<div class="flex-1 min-w-0">
<div class="font-body-md text-on-surface font-medium truncate">Luis Ramirez Soto</div>
<div class="font-label-sm text-on-surface-variant flex items-center gap-2">
<span class="material-symbols-outlined text-[14px]">badge</span> 76543210
            </div>
</div>
<div class="flex flex-col items-end shrink-0">
<span class="bg-surface-container-highest text-on-surface-variant px-2 py-1 rounded-md font-label-sm flex items-center gap-1">
<span class="material-symbols-outlined text-[12px]">pending</span> --:--
            </span>
</div>
</label>
</div>
</div>
</main>
<!-- Quick Action FAB -->
<button aria-label="Quick Scan" class="fixed bottom-6 right-6 w-14 h-14 bg-secondary text-on-secondary rounded-2xl shadow-lg flex items-center justify-center hover:bg-secondary/90 transition-transform active:scale-95 z-30">
<span class="material-symbols-outlined text-3xl">qr_code_scanner</span>
</button>
<style>
    /* Hide scrollbar for tabs */
    .hide-scrollbar::-webkit-scrollbar {
      display: none;
    }
    .hide-scrollbar {
      -ms-overflow-style: none;
      scrollbar-width: none;
    }
  </style>
<script>
    document.addEventListener('DOMContentLoaded', () => {
      const toggles = document.querySelectorAll('.accordion-toggle');
      
      toggles.forEach(toggle => {
        toggle.addEventListener('click', () => {
          const content = toggle.nextElementSibling;
          const icon = toggle.querySelector('.icon-chevron');
          
          if (content.classList.contains('hidden')) {
            content.classList.remove('hidden');
            icon.classList.add('rotate-180');
          } else {
            content.classList.add('hidden');
            icon.classList.remove('rotate-180');
          }
        });
      });
    });
  </script>
</div></main></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><style>@layer base{html,body{width:100vw;margin:0;padding:0;overflow-x:hidden;}body{overscroll-behavior:none;}.pb-safe{padding-bottom:env(safe-area-inset-bottom,0px);}.pt-safe{padding-top:env(safe-area-inset-top,0px);}}::-webkit-scrollbar{display:none;}</style><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "surface-dim": "#d9dadb", "surface-container-low": "#f3f4f5", "outline": "#717973", "on-secondary-fixed": "#002113", "primary": "#012d1d", "secondary-container": "#92f7c3", "on-secondary-fixed-variant": "#005235", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "surface-container": "#edeeef", "error-container": "#ffdad6", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "tertiary-fixed-dim": "#f2bb98", "on-background": "#191c1d", "secondary-fixed-dim": "#75daa8", "surface-bright": "#f8f9fa", "on-tertiary-container": "#cf9b7a", "on-surface": "#191c1d", "surface-container-lowest": "#ffffff", "on-secondary-container": "#00734d", "on-tertiary-fixed": "#301401", "on-error-container": "#93000a", "tertiary-container": "#57331a", "secondary": "#006c48", "tertiary": "#3d1e07", "inverse-on-surface": "#f0f1f2", "on-error": "#ffffff", "primary-container": "#1b4332", "on-primary-container": "#86af99", "on-primary": "#ffffff", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "background": "#f8f9fa", "primary-fixed": "#c1ecd4", "tertiary-fixed": "#ffdcc7", "error": "#ba1a1a", "surface": "#f8f9fa", "on-primary-fixed-variant": "#274e3d", "secondary-fixed": "#92f7c3", "surface-tint": "#3f6653", "surface-container-highest": "#e1e3e4", "inverse-primary": "#a5d0b9", "on-secondary": "#ffffff" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "xs": "4px", "lg": "24px", "sm": "12px", "md": "16px", "gutter": "16px", "margin-mobile": "16px", "margin-desktop": "32px", "xl": "40px", "base": "8px" }, "fontFamily": { "label-sm": ["Inter"], "body-md": ["Inter"], "headline-lg-mobile": ["Inter"], "body-lg": ["Inter"], "title-md": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "display-lg": ["Inter"] } } } }</script><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background font-body-md text-on-surface"><header class="fixed top-0 w-full z-50 bg-primary shadow-[0_1px_8px_rgba(0,0,0,0.08)] pt-safe"><div class="h-16 px-margin-mobile flex items-center justify-between"><div class="flex items-center gap-sm"><img alt="Logo" class="h-8 w-auto object-contain" src="https://lh3.googleusercontent.com/aida/AP1WRLuzBrAuQDA_gVdwYmkqM6yVUZDD0FfhANFqFGF_rQ3eICg_WM-MiJX0NDHidmQeznjBg8fc-GzrZomWrOffpGWmNL_shnJ6GvWoOR657SgQoGAJ-bSY1q-9R8Ckc45T-aCvQzjTo3vbZjxlpmyfVCmdavV2UydYbO-0pGKjqB5kaWkh5_zAjfedyfJyAdRYm-FyU3vSpkqvf4Dd4ZgeIFnoPH0GDwhRMymEtFB1y5rt6y2NoMWgBM57Ibx_"/><span class="font-title-md text-title-md text-on-primary tracking-tight">Productividad</span></div><div class="flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full active:bg-primary-container/20"><span class="material-symbols-outlined text-on-primary">sync</span></button><img alt="Profile" class="w-8 h-8 rounded-full border border-on-primary/20 object-cover" src="https://lh3.googleusercontent.com/aida/AP1WRLs15O3tSz7vyMk4ncVq5E7_oUkzCCjc1zGJAbDY-gHZAd4kT3ntCXYXYHi52dSgW1ieCRkrkVPslgQ3BaM8IZSOB1AdJL4O-Rdz88d8bbyQhEg3aW7pmTKxPFVUWAGbUCtbKGJJvh_-8LL4jy3jKsxNz2uE07AuxHKzyELe2k9CFkAFMWUBJ0AW5b-9TXgj5_peb8yeR81kyXOcKm1KwhZNVYXsIFBhQMWIDs06EOQF37QD_i7-A-o2YhKu"/></div></div></header><main class="flex flex-col relative w-full pt-16 bg-surface min-h-screen pb-24"><div class="flex flex-col w-full h-full relative bg-surface">
<!-- Date & Search Bar Header -->
<div class="px-margin-mobile py-md bg-surface flex flex-col gap-sm sticky top-0 z-10 shadow-sm">
<div class="flex items-center justify-between bg-surface-container rounded-lg p-sm shadow-sm cursor-pointer active:scale-[0.98] transition-transform">
<div class="flex items-center gap-xs text-on-surface">
<span class="material-symbols-outlined text-primary">calendar_month</span>
<span class="font-label-md text-label-md font-semibold">Hoy, 24 Octubre 2023</span>
</div>
<span class="material-symbols-outlined text-outline">expand_more</span>
</div>
<div class="flex items-center bg-surface-container rounded-lg px-sm h-12 shadow-sm focus-within:ring-2 focus-within:ring-primary transition-shadow">
<span class="material-symbols-outlined text-outline mr-sm">search</span>
<input class="bg-transparent font-body-md text-on-surface w-full h-full outline-none placeholder:text-outline/70" placeholder="Buscar trabajador por nombre o DNI..." type="text"/>
</div>
</div>
<!-- Quick Stats -->
<div class="px-margin-mobile py-sm grid grid-cols-2 gap-sm">
<div class="bg-primary-container rounded-xl p-md flex flex-col justify-between shadow-sm relative overflow-hidden">
<div class="absolute -right-4 -bottom-4 w-16 h-16 bg-primary opacity-10 rounded-full blur-xl"></div>
<span class="font-label-sm text-on-primary-container mb-xs">Total Cosechado</span>
<div class="flex items-end gap-xs">
<span class="font-display-lg text-on-primary-container tracking-tight">4,250</span>
<span class="font-label-md text-on-primary-container/80 pb-sm">kg</span>
</div>
</div>
<div class="bg-surface-container-high rounded-xl p-md flex flex-col justify-between shadow-sm">
<span class="font-label-sm text-on-surface-variant mb-xs">Promedio/Trabajador</span>
<div class="flex items-end gap-xs">
<span class="font-headline-lg-mobile text-on-surface">85</span>
<span class="font-label-md text-on-surface-variant pb-xs">kg</span>
</div>
</div>
</div>
<!-- Worker List -->
<div class="flex-1 flex flex-col px-margin-mobile py-sm gap-sm pb-32">
<h2 class="font-title-md text-on-surface mb-xs">Rendimiento Individual</h2>
<!-- High Performer Card -->
<div class="bg-surface-container-lowest rounded-xl p-md shadow-md flex items-center justify-between relative overflow-hidden active:scale-[0.99] transition-transform">
<div class="absolute left-0 top-0 bottom-0 w-1 bg-secondary"></div>
<div class="flex items-center gap-sm">
<div class="w-12 h-12 rounded-full bg-secondary-container flex items-center justify-center text-on-secondary-container font-title-md font-bold">
                    JP
                 </div>
<div class="flex flex-col">
<span class="font-label-md text-on-surface font-semibold">Juan Pérez</span>
<span class="font-label-sm text-on-surface-variant">DNI: 45678912</span>
</div>
</div>
<div class="flex flex-col items-end">
<div class="flex items-end gap-xs">
<span class="font-headline-lg-mobile text-secondary font-bold">120</span>
<span class="font-label-sm text-on-surface-variant pb-xs">kg</span>
</div>
<div class="flex items-center gap-xs mt-xs bg-secondary-container/30 px-xs py-0.5 rounded-sm">
<span class="material-symbols-outlined text-[14px] text-secondary">trending_up</span>
<span class="font-label-sm text-secondary text-[10px]">+15%</span>
</div>
</div>
</div>
<!-- Average Performer Card -->
<div class="bg-surface-container-lowest rounded-xl p-md shadow-sm flex items-center justify-between active:scale-[0.99] transition-transform">
<div class="flex items-center gap-sm">
<img class="w-12 h-12 rounded-full object-cover shadow-sm" data-alt="Portrait of an agricultural worker, medium shot, natural lighting, professional farming attire, warm tones, confident expression." src="https://lh3.googleusercontent.com/aida-public/AB6AXuBjBYNM88vdEfcnl8CiMJkfwdKLwziqW1RQVxp-PFjSrKD1I_iSuoSh5Y0JqkolHtNfdQZk9V07NVurWHUUt4HQD7RPxnJOaAZxRtIj3SICm-dptlRZb4ZrDqlBV8OKefNqW3jS34dm2ar_PPLLpmwYaLPfOQUj8-eNtJl1HUOq2odoH6Pc0RU1kjidxstphlYTV2HG-3323Vj7PhUGO5wImpevb6uodtE3ddciGX8y6MFPv-X1y_8iHA"/>
<div class="flex flex-col">
<span class="font-label-md text-on-surface font-semibold">María Gonzáles</span>
<span class="font-label-sm text-on-surface-variant">DNI: 78912345</span>
</div>
</div>
<div class="flex flex-col items-end">
<div class="flex items-end gap-xs">
<span class="font-headline-lg-mobile text-on-surface font-bold">95</span>
<span class="font-label-sm text-on-surface-variant pb-xs">kg</span>
</div>
</div>
</div>
<!-- Low Performer Card -->
<div class="bg-surface-container-lowest rounded-xl p-md shadow-sm flex items-center justify-between relative overflow-hidden active:scale-[0.99] transition-transform">
<div class="absolute left-0 top-0 bottom-0 w-1 bg-tertiary"></div>
<div class="flex items-center gap-sm">
<div class="w-12 h-12 rounded-full bg-surface-variant flex items-center justify-center text-on-surface-variant font-title-md font-bold">
                    CR
                 </div>
<div class="flex flex-col">
<span class="font-label-md text-on-surface font-semibold">Carlos Ramírez</span>
<span class="font-label-sm text-on-surface-variant">DNI: 12345678</span>
</div>
</div>
<div class="flex flex-col items-end">
<div class="flex items-end gap-xs">
<span class="font-headline-lg-mobile text-tertiary font-bold">65</span>
<span class="font-label-sm text-on-surface-variant pb-xs">kg</span>
</div>
<div class="flex items-center gap-xs mt-xs bg-error-container/30 px-xs py-0.5 rounded-sm">
<span class="material-symbols-outlined text-[14px] text-error">trending_down</span>
<span class="font-label-sm text-error text-[10px]">-10%</span>
</div>
</div>
</div>
<!-- Average Performer Card -->
<div class="bg-surface-container-lowest rounded-xl p-md shadow-sm flex items-center justify-between active:scale-[0.99] transition-transform">
<div class="flex items-center gap-sm">
<div class="w-12 h-12 rounded-full bg-surface-variant flex items-center justify-center text-on-surface-variant font-title-md font-bold">
                    AT
                 </div>
<div class="flex flex-col">
<span class="font-label-md text-on-surface font-semibold">Ana Torres</span>
<span class="font-label-sm text-on-surface-variant">DNI: 87654321</span>
</div>
</div>
<div class="flex flex-col items-end">
<div class="flex items-end gap-xs">
<span class="font-headline-lg-mobile text-on-surface font-bold">88</span>
<span class="font-label-sm text-on-surface-variant pb-xs">kg</span>
</div>
</div>
</div>
</div>
<!-- Floating Action Button for quick scan/entry -->
<button class="fixed bottom-20 right-margin-mobile w-14 h-14 bg-secondary rounded-full flex items-center justify-center shadow-lg active:scale-90 transition-transform z-20">
<span class="material-symbols-outlined text-on-secondary">qr_code_scanner</span>
</button>
</div></main><nav class="fixed bottom-0 w-full z-50 pb-safe bg-surface/95 backdrop-blur-md shadow-[0_-1px_12px_rgba(0,0,0,0.04)]" data-active-classes="text-secondary bg-secondary-container/30 rounded-xl"><div class="flex justify-between items-center h-16 px-xs"><a class="flex flex-col items-center justify-center flex-1 h-14 gap-xs text-on-surface-variant transition-colors" data-path="inicio" href="#"><span class="material-symbols-outlined">home</span><span class="font-label-sm text-label-sm">Inicio</span></a><a class="flex flex-col items-center justify-center flex-1 h-14 gap-xs text-on-surface-variant transition-colors" data-path="tareo" href="#"><span class="material-symbols-outlined">assignment_turned_in</span><span class="font-label-sm text-label-sm">Tareo</span></a><a class="flex flex-col items-center justify-center flex-1 h-14 gap-xs text-on-surface-variant transition-colors" data-path="personal" href="#"><span class="material-symbols-outlined">groups</span><span class="font-label-sm text-label-sm">Personal</span></a><a aria-current="page" class="flex flex-col items-center justify-center flex-1 h-14 gap-xs transition-colors text-secondary bg-secondary-container/30 rounded-xl" data-path="productividad" href="#"><span class="material-symbols-outlined">trending_up</span><span class="font-label-sm text-label-sm">Productividad</span></a><a class="flex flex-col items-center justify-center flex-1 h-14 gap-xs text-on-surface-variant transition-colors" data-path="resumen" href="#"><span class="material-symbols-outlined">assessment</span><span class="font-label-sm text-label-sm">Resumen</span></a></div></nav></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><style>@layer base{html,body{width:100vw;margin:0;padding:0;}body{overscroll-behavior:none;}.pb-safe{padding-bottom:env(safe-area-inset-bottom,0px);}.pt-safe{padding-top:env(safe-area-inset-top,0px);}}::-webkit-scrollbar{display:none;}</style><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "surface-dim": "#d9dadb", "surface-container-low": "#f3f4f5", "outline": "#717973", "on-secondary-fixed": "#002113", "primary": "#012d1d", "secondary-container": "#92f7c3", "on-secondary-fixed-variant": "#005235", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "surface-container": "#edeeef", "error-container": "#ffdad6", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "tertiary-fixed-dim": "#f2bb98", "on-background": "#191c1d", "secondary-fixed-dim": "#75daa8", "surface-bright": "#f8f9fa", "on-tertiary-container": "#cf9b7a", "on-surface": "#191c1d", "surface-container-lowest": "#ffffff", "on-secondary-container": "#00734d", "on-tertiary-fixed": "#301401", "on-error-container": "#93000a", "tertiary-container": "#57331a", "secondary": "#006c48", "tertiary": "#3d1e07", "inverse-on-surface": "#f0f1f2", "on-error": "#ffffff", "primary-container": "#1b4332", "on-primary-container": "#86af99", "on-primary": "#ffffff", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "background": "#f8f9fa", "primary-fixed": "#c1ecd4", "tertiary-fixed": "#ffdcc7", "error": "#ba1a1a", "surface": "#f8f9fa", "on-primary-fixed-variant": "#274e3d", "secondary-fixed": "#92f7c3", "surface-tint": "#3f6653", "surface-container-highest": "#e1e3e4", "inverse-primary": "#a5d0b9", "on-secondary": "#ffffff" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "xs": "4px", "lg": "24px", "sm": "12px", "md": "16px", "gutter": "16px", "margin-mobile": "16px", "margin-desktop": "32px", "xl": "40px", "base": "8px" }, "fontFamily": { "label-sm": ["Inter"], "body-md": ["Inter"], "headline-lg-mobile": ["Inter"], "body-lg": ["Inter"], "title-md": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "display-lg": ["Inter"] } } } }</script><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background font-body-md text-on-surface"><header class="fixed top-0 w-full z-50 bg-primary pt-safe shadow-md"><div class="h-16 px-4 flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full text-on-primary active:bg-primary-container/20" onclick="history.back()"><span class="material-symbols-outlined">arrow_back</span></button><div class="flex-1"><h1 class="font-title-md text-title-md text-on-primary truncate">Configuración</h1></div><img alt="Profile" class="w-8 h-8 rounded-full border border-on-primary/20 object-cover" src="https://lh3.googleusercontent.com/aida/AP1WRLs15O3tSz7vyMk4ncVq5E7_oUkzCCjc1zGJAbDY-gHZAd4kT3ntCXYXYHi52dSgW1ieCRkrkVPslgQ3BaM8IZSOB1AdJL4O-Rdz88d8bbyQhEg3aW7pmTKxPFVUWAGbUCtbKGJJvh_-8LL4jy3jKsxNz2uE07AuxHKzyELe2k9CFkAFMWUBJ0AW5b-9TXgj5_peb8yeR81kyXOcKm1KwhZNVYXsIFBhQMWIDs06EOQF37QD_i7-A-o2YhKu"/></div></header><main class="flex flex-col relative w-full pt-16 bg-surface"><div class="flex flex-col w-full pb-safe">
<!-- Perfil Section -->
<div class="px-md py-sm mt-md">
<h2 class="font-label-md text-primary tracking-wide mb-sm px-xs">PERFIL DEL SUPERVISOR</h2>
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.04)] mb-md">
<div class="flex items-center p-md border-b border-surface-variant">
<div class="relative">
<img class="w-16 h-16 rounded-full object-cover" data-alt="Close up professional headshot of a rugged agricultural supervisor, warm natural lighting, confident expression, earthy tones, green background" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAcic_Qvt6-rHU86t7PIzzE8vcrpcPf0-vutByRu5ZAsvDIZkbC3lGlcnLTi5FLmlB_1OnjYzsbOWrg9QpPY6z7CmBr466W2p2Ys2pdLXoRzo-mNuD2Nm2gZ2g68MHFuB1qmmt8DloLnU494zW9NFUboSO-z7l6GmS9baUFGsnyHxkak6B2j-AfV-Fz99sJpwEAmVpuI3Tp3mIyeOMQvgbSaLFYEyhK3gWPHo6oCgxd8X6BGnBt2Zw8Dw"/>
<div class="absolute bottom-0 right-0 w-4 h-4 bg-secondary rounded-full border-2 border-surface-container-lowest"></div>
</div>
<div class="ml-md">
<h3 class="font-title-md text-on-surface">Carlos Mendoza</h3>
<p class="font-body-md text-on-surface-variant">Agrónomo Jefe - Zona Norte</p>
<span class="inline-block mt-xs bg-primary-container text-on-primary-container font-label-sm px-2 py-0.5 rounded-full">ID: SUP-4921</span>
</div>
</div>
<button class="w-full flex items-center justify-between p-md hover:bg-surface-container-low transition-colors active:bg-surface-container text-left rounded-b-xl">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">badge</span>
<span class="font-body-md text-on-surface">Editar información personal</span>
</div>
<span class="material-symbols-outlined text-outline">chevron_right</span>
</button>
</div>
</div>
<!-- Sincronización Section -->
<div class="px-md py-sm">
<h2 class="font-label-md text-primary tracking-wide mb-sm px-xs">SINCRONIZACIÓN Y DATOS</h2>
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.04)] mb-md overflow-hidden">
<div class="p-md bg-surface-container-low border-b border-surface-variant flex justify-between items-center">
<div>
<div class="flex items-center gap-xs mb-1">
<span class="material-symbols-outlined text-secondary text-sm">cloud_done</span>
<span class="font-title-md text-on-surface text-sm">Estado: Conectado</span>
</div>
<p class="font-label-sm text-on-surface-variant">Última sinc: Hace 5 min</p>
</div>
<button class="bg-primary text-on-primary rounded-lg px-md py-sm font-label-md flex items-center gap-xs active:bg-primary/90 transition-transform active:scale-95">
<span class="material-symbols-outlined text-sm">sync</span>
<span>Sincronizar</span>
</button>
</div>
<button class="w-full flex items-center justify-between p-md border-b border-surface-variant hover:bg-surface-container-low transition-colors active:bg-surface-container text-left">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">offline_pin</span>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Descargar mapas offline</span>
<span class="font-label-sm text-on-surface-variant">Lotes 1A - 4C (12 MB)</span>
</div>
</div>
<span class="material-symbols-outlined text-outline">download</span>
</button>
<button class="w-full flex items-center justify-between p-md hover:bg-surface-container-low transition-colors active:bg-surface-container text-left">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">history</span>
<span class="font-body-md text-on-surface">Historial de tareos locales</span>
</div>
<div class="flex items-center gap-xs">
<span class="bg-error-container text-on-error-container font-label-sm px-2 py-0.5 rounded-full">3 pdtes</span>
<span class="material-symbols-outlined text-outline">chevron_right</span>
</div>
</button>
</div>
</div>
<!-- Dispositivo Section -->
<div class="px-md py-sm">
<h2 class="font-label-md text-primary tracking-wide mb-sm px-xs">CONFIGURACIÓN DEL DISPOSITIVO</h2>
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.04)] mb-md overflow-hidden">
<div class="w-full flex items-center justify-between p-md border-b border-surface-variant">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">photo_camera</span>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Calidad de escaneo QR</span>
<span class="font-label-sm text-on-surface-variant">Alta resolución (Recomendado)</span>
</div>
</div>
<!-- Toggle Switch -->
<label class="relative inline-flex items-center cursor-pointer">
<input checked="" class="sr-only peer" type="checkbox" value=""/>
<div class="w-11 h-6 bg-surface-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-secondary"></div>
</label>
</div>
<div class="w-full flex items-center justify-between p-md border-b border-surface-variant">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">location_on</span>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">GPS Precisión Alta</span>
<span class="font-label-sm text-on-surface-variant">Consume más batería</span>
</div>
</div>
<!-- Toggle Switch -->
<label class="relative inline-flex items-center cursor-pointer">
<input checked="" class="sr-only peer" type="checkbox" value=""/>
<div class="w-11 h-6 bg-surface-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-secondary"></div>
</label>
</div>
<button class="w-full flex items-center justify-between p-md hover:bg-surface-container-low transition-colors active:bg-surface-container text-left">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">storage</span>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Almacenamiento</span>
<div class="w-32 h-1.5 bg-surface-variant rounded-full mt-1 overflow-hidden">
<div class="bg-primary h-full rounded-full" style="width: 65%"></div>
</div>
</div>
</div>
<span class="font-label-sm text-on-surface-variant">65% Lleno</span>
</button>
</div>
</div>
<!-- Acerca de Section -->
<div class="px-md py-sm">
<h2 class="font-label-md text-primary tracking-wide mb-sm px-xs">ACERCA DE</h2>
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.04)] mb-md overflow-hidden">
<button class="w-full flex items-center justify-between p-md border-b border-surface-variant hover:bg-surface-container-low transition-colors active:bg-surface-container text-left">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">help</span>
<span class="font-body-md text-on-surface">Centro de ayuda y soporte</span>
</div>
<span class="material-symbols-outlined text-outline">chevron_right</span>
</button>
<div class="w-full flex items-center justify-between p-md text-left">
<div class="flex items-center gap-sm">
<span class="material-symbols-outlined text-on-surface-variant">info</span>
<span class="font-body-md text-on-surface">Versión de la App</span>
</div>
<span class="font-label-sm text-on-surface-variant">v2.4.1 (Build 892)</span>
</div>
</div>
</div>
<!-- Logout Button -->
<div class="px-md py-xl mt-auto">
<button class="w-full flex items-center justify-center gap-sm py-sm rounded-lg border-2 border-error text-error font-title-md bg-surface-container-lowest hover:bg-error-container active:scale-95 transition-all">
<span class="material-symbols-outlined">logout</span>
          Cerrar Sesión
      </button>
</div>
</div></main></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><style>@layer base{html,body{width:100vw;margin:0;padding:0;}body{overscroll-behavior:none;}.pb-safe{padding-bottom:env(safe-area-inset-bottom,0px);}.pt-safe{padding-top:env(safe-area-inset-top,0px);}}::-webkit-scrollbar{display:none;}</style><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "surface-dim": "#d9dadb", "surface-container-low": "#f3f4f5", "outline": "#717973", "on-secondary-fixed": "#002113", "primary": "#012d1d", "secondary-container": "#92f7c3", "on-secondary-fixed-variant": "#005235", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "surface-container": "#edeeef", "error-container": "#ffdad6", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "tertiary-fixed-dim": "#f2bb98", "on-background": "#191c1d", "secondary-fixed-dim": "#75daa8", "surface-bright": "#f8f9fa", "on-tertiary-container": "#cf9b7a", "on-surface": "#191c1d", "surface-container-lowest": "#ffffff", "on-secondary-container": "#00734d", "on-tertiary-fixed": "#301401", "on-error-container": "#93000a", "tertiary-container": "#57331a", "secondary": "#006c48", "tertiary": "#3d1e07", "inverse-on-surface": "#f0f1f2", "on-error": "#ffffff", "primary-container": "#1b4332", "on-primary-container": "#86af99", "on-primary": "#ffffff", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "background": "#f8f9fa", "primary-fixed": "#c1ecd4", "tertiary-fixed": "#ffdcc7", "error": "#ba1a1a", "surface": "#f8f9fa", "on-primary-fixed-variant": "#274e3d", "secondary-fixed": "#92f7c3", "surface-tint": "#3f6653", "surface-container-highest": "#e1e3e4", "inverse-primary": "#a5d0b9", "on-secondary": "#ffffff" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "xs": "4px", "lg": "24px", "sm": "12px", "md": "16px", "gutter": "16px", "margin-mobile": "16px", "margin-desktop": "32px", "xl": "40px", "base": "8px" }, "fontFamily": { "label-sm": ["Inter"], "body-md": ["Inter"], "headline-lg-mobile": ["Inter"], "body-lg": ["Inter"], "title-md": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "display-lg": ["Inter"] } } } }</script><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background font-body-md text-on-surface"><header class="fixed top-0 w-full z-50 bg-primary pt-safe shadow-md"><div class="h-16 px-4 flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full text-on-primary active:bg-primary-container/20" onclick="history.back()"><span class="material-symbols-outlined">arrow_back</span></button><div class="flex-1"><h1 class="font-title-md text-title-md text-on-primary truncate">Ficha De Trabajador</h1></div><img alt="Profile" class="w-8 h-8 rounded-full border border-on-primary/20 object-cover" src="https://lh3.googleusercontent.com/aida/AP1WRLs15O3tSz7vyMk4ncVq5E7_oUkzCCjc1zGJAbDY-gHZAd4kT3ntCXYXYHi52dSgW1ieCRkrkVPslgQ3BaM8IZSOB1AdJL4O-Rdz88d8bbyQhEg3aW7pmTKxPFVUWAGbUCtbKGJJvh_-8LL4jy3jKsxNz2uE07AuxHKzyELe2k9CFkAFMWUBJ0AW5b-9TXgj5_peb8yeR81kyXOcKm1KwhZNVYXsIFBhQMWIDs06EOQF37QD_i7-A-o2YhKu"/></div></header><main class="flex flex-col relative w-full pt-16 bg-surface"><div class="flex flex-col w-full pb-safe">
<!-- Profile Header -->
<section class="bg-surface-container pb-md shadow-sm">
<div class="px-md flex flex-col items-center justify-center pt-xl">
<div class="w-24 h-24 rounded-full bg-primary-container text-on-primary-container flex items-center justify-center font-display-lg shadow-sm mb-md relative">
        JM
        <div class="absolute bottom-0 right-0 w-6 h-6 bg-secondary rounded-full flex items-center justify-center border-2 border-surface-container">
<span class="material-symbols-outlined text-[14px] text-on-secondary" style="font-variation-settings: 'FILL' 1;">check_circle</span>
</div>
</div>
<h2 class="font-headline-lg-mobile text-on-surface text-center px-4 leading-tight mb-xs">Juan Carlos Mendoza</h2>
<p class="font-body-md text-on-surface-variant text-center">DNI: 72839401</p>
<div class="flex gap-sm mt-md w-full max-w-sm px-4">
<button class="flex-1 h-11 bg-primary text-on-primary rounded-lg font-label-md flex items-center justify-center gap-xs shadow-sm active:bg-primary/90 transition-colors">
<span class="material-symbols-outlined text-[20px]">edit</span>
          Editar Datos
        </button>
<button class="flex-1 h-11 bg-surface-container-highest text-on-surface flex items-center justify-center rounded-lg font-label-md gap-xs active:bg-surface-container-highest/80 transition-colors">
<span class="material-symbols-outlined text-[20px]">history</span>
           Historial Completo
        </button>
</div>
</div>
</section>
<!-- Weekly Summary Card -->
<section class="px-md py-md mt-sm">
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_16px_rgba(0,0,0,0.04)] overflow-hidden">
<div class="p-4 bg-surface-container-low flex items-center justify-between">
<h3 class="font-title-md text-on-surface">Resumen Semanal</h3>
<span class="font-label-sm text-on-surface-variant bg-surface px-2 py-1 rounded">Semana 42</span>
</div>
<div class="grid grid-cols-2 p-md gap-md">
<div class="flex flex-col">
<div class="flex items-center gap-xs mb-xs">
<span class="material-symbols-outlined text-secondary text-[20px]">schedule</span>
<span class="font-label-md text-on-surface-variant">Horas Totales</span>
</div>
<span class="font-headline-lg-mobile text-on-surface">42.5 h</span>
<span class="font-label-sm text-secondary flex items-center mt-1">
<span class="material-symbols-outlined text-[14px] mr-1">trending_up</span> +2.5h vs sem pasada
          </span>
</div>
<div class="flex flex-col">
<div class="flex items-center gap-xs mb-xs">
<span class="material-symbols-outlined text-tertiary text-[20px]">scale</span>
<span class="font-label-md text-on-surface-variant">Rendimiento</span>
</div>
<span class="font-headline-lg-mobile text-on-surface">845 Kg</span>
<span class="font-label-sm text-on-surface-variant flex items-center mt-1">
             Palta Hass (Cosecha)
          </span>
</div>
</div>
<!-- Mini Chart Placeholder -->
<div class="px-md pb-md">
<div class="w-full h-16 flex items-end justify-between gap-1 mt-2">
<!-- Bars representing days Mon-Sun -->
<div class="w-full bg-secondary-container rounded-t-sm h-full relative group">
<div class="absolute -top-6 left-1/2 -translate-x-1/2 bg-inverse-surface text-inverse-on-surface font-label-sm px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">8h</div>
</div>
<div class="w-full bg-secondary-container rounded-t-sm h-[90%] relative group"></div>
<div class="w-full bg-secondary-container rounded-t-sm h-[100%] relative group"></div>
<div class="w-full bg-secondary-container rounded-t-sm h-[85%] relative group"></div>
<div class="w-full bg-secondary-container rounded-t-sm h-[95%] relative group"></div>
<div class="w-full bg-surface-variant rounded-t-sm h-[40%] relative group"></div>
<div class="w-full bg-surface-variant rounded-t-sm h-1 relative group"></div>
</div>
<div class="flex justify-between mt-1 px-1">
<span class="font-label-sm text-on-surface-variant text-[10px]">L</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">M</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">M</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">J</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">V</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">S</span>
<span class="font-label-sm text-on-surface-variant text-[10px]">D</span>
</div>
</div>
</div>
</section>
<!-- Recent Activities -->
<section class="px-md pb-xl">
<h3 class="font-title-md text-on-surface mb-md">Actividades Recientes</h3>
<div class="flex flex-col gap-sm">
<!-- Activity Item 1 -->
<div class="bg-surface-container-lowest p-md rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.03)] flex flex-col">
<div class="flex justify-between items-start mb-sm">
<div class="flex items-center gap-2">
<div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">eco</span>
</div>
<div>
<h4 class="font-label-md text-on-surface">Cosecha - Lote A2</h4>
<p class="font-label-sm text-on-surface-variant">Hoy, 06:00 - 14:30</p>
</div>
</div>
<span class="bg-secondary/10 text-secondary font-label-sm px-2 py-1 rounded">Completado</span>
</div>
<div class="bg-surface-container p-sm rounded-lg flex justify-between items-center">
<span class="font-label-sm text-on-surface-variant">Rendimiento: 120 Kg</span>
<span class="font-label-sm text-on-surface-variant">Horas: 8.5h</span>
</div>
</div>
<!-- Activity Item 2 -->
<div class="bg-surface-container-lowest p-md rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.03)] flex flex-col">
<div class="flex justify-between items-start mb-sm">
<div class="flex items-center gap-2">
<div class="w-10 h-10 rounded-full bg-tertiary/10 flex items-center justify-center text-tertiary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">grass</span>
</div>
<div>
<h4 class="font-label-md text-on-surface">Poda - Lote B1</h4>
<p class="font-label-sm text-on-surface-variant">Ayer, 06:00 - 15:00</p>
</div>
</div>
<span class="bg-secondary/10 text-secondary font-label-sm px-2 py-1 rounded">Completado</span>
</div>
<div class="bg-surface-container p-sm rounded-lg flex justify-between items-center">
<span class="font-label-sm text-on-surface-variant">Avance: 15 Surcos</span>
<span class="font-label-sm text-on-surface-variant">Horas: 9h</span>
</div>
</div>
<!-- Activity Item 3 -->
<div class="bg-surface-container-lowest p-md rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.03)] flex flex-col">
<div class="flex justify-between items-start mb-sm">
<div class="flex items-center gap-2">
<div class="w-10 h-10 rounded-full bg-primary/10 flex items-center justify-center text-primary">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">eco</span>
</div>
<div>
<h4 class="font-label-md text-on-surface">Cosecha - Lote A2</h4>
<p class="font-label-sm text-on-surface-variant">12 Oct, 06:00 - 14:00</p>
</div>
</div>
<span class="bg-secondary/10 text-secondary font-label-sm px-2 py-1 rounded">Completado</span>
</div>
<div class="bg-surface-container p-sm rounded-lg flex justify-between items-center">
<span class="font-label-sm text-on-surface-variant">Rendimiento: 115 Kg</span>
<span class="font-label-sm text-on-surface-variant">Horas: 8h</span>
</div>
</div>
</div>
</section>
</div></main></body></html>
<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0,0" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "primary-fixed-dim": "#a5d0b9", "tertiary-fixed-dim": "#f2bb98", "secondary-fixed-dim": "#75daa8", "on-tertiary-container": "#cf9b7a", "on-secondary-fixed-variant": "#005235", "surface-container-high": "#e7e8e9", "inverse-surface": "#2e3132", "tertiary": "#3d1e07", "primary": "#012d1d", "surface-dim": "#d9dadb", "surface-tint": "#3f6653", "on-primary-container": "#86af99", "inverse-on-surface": "#f0f1f2", "on-primary-fixed-variant": "#274e3d", "on-surface": "#191c1d", "tertiary-container": "#57331a", "surface-container-lowest": "#ffffff", "secondary-fixed": "#92f7c3", "error": "#ba1a1a", "inverse-primary": "#a5d0b9", "surface-container-low": "#f3f4f5", "on-secondary": "#ffffff", "on-tertiary": "#ffffff", "outline-variant": "#c1c8c2", "surface": "#f8f9fa", "background": "#f8f9fa", "primary-container": "#1b4332", "on-error-container": "#93000a", "surface-bright": "#f8f9fa", "primary-fixed": "#c1ecd4", "on-tertiary-fixed-variant": "#643e24", "on-surface-variant": "#414844", "secondary": "#006c48", "on-primary-fixed": "#002114", "surface-variant": "#e1e3e4", "tertiary-fixed": "#ffdcc7", "outline": "#717973", "on-secondary-container": "#00734d", "surface-container-highest": "#e1e3e4", "surface-container": "#edeeef", "on-secondary-fixed": "#002113", "error-container": "#ffdad6", "on-background": "#191c1d", "secondary-container": "#92f7c3", "on-primary": "#ffffff", "on-error": "#ffffff", "on-tertiary-fixed": "#301401" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "lg": "24px", "gutter": "16px", "margin-desktop": "32px", "base": "8px", "xl": "40px", "xs": "4px", "sm": "12px", "margin-mobile": "16px", "md": "16px" }, "fontFamily": { "body-md": ["Inter"], "body-lg": ["Inter"], "headline-lg-mobile": ["Inter"], "label-md": ["Inter"], "headline-lg": ["Inter"], "title-md": ["Inter"], "display-lg": ["Inter"], "label-sm": ["Inter"] } } } }</script><style>@layer base { .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0); } .pt-safe { padding-top: env(safe-area-inset-top, 0); } } </style><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
  </head><body class="bg-background text-on-surface font-body-md overflow-x-hidden pt-safe pb-safe"><main class="min-h-screen w-full relative flex flex-col"><div class="flex flex-col w-full h-full relative">
<!-- Header -->
<header class="bg-primary text-on-primary px-margin-mobile py-4 flex items-center justify-between sticky top-0 z-10 shadow-sm">
<button aria-label="Go back" class="w-11 h-11 flex items-center justify-center rounded-full hover:bg-primary-fixed-dim/20 transition-colors">
<span class="material-symbols-outlined text-title-md">arrow_back</span>
</button>
<h1 class="font-title-md flex-1 text-center pr-11">Labores por parcela</h1>
</header>
<!-- Content Scrollable Area -->
<div class="flex-1 overflow-y-auto pb-[80px] bg-background">
<!-- Summary Section -->
<section class="p-margin-mobile">
<div class="bg-surface-container-lowest rounded-xl shadow-[0_4px_12px_rgba(0,0,0,0.04)] p-sm flex items-center justify-between relative overflow-hidden">
<div class="absolute inset-y-0 left-0 w-1 bg-secondary rounded-l-xl"></div>
<div class="flex flex-col pl-xs">
<span class="font-label-sm text-on-surface-variant uppercase tracking-wider mb-1">Parcela</span>
<h2 class="font-title-md text-on-surface">P24 - Zona Sur</h2>
</div>
<div class="flex items-center gap-4">
<div class="flex flex-col items-center bg-surface-container-low px-3 py-2 rounded-lg">
<span class="material-symbols-outlined text-tertiary-container mb-1" style="font-variation-settings: 'FILL' 1;">groups</span>
<span class="font-label-md text-on-surface font-bold">4</span>
</div>
<div class="flex flex-col items-center bg-surface-container-low px-3 py-2 rounded-lg">
<span class="material-symbols-outlined text-primary-container mb-1" style="font-variation-settings: 'FILL' 1;">schedule</span>
<span class="font-label-md text-on-surface font-bold">4h</span>
</div>
</div>
</div>
</section>
<!-- Grouped List by Activity -->
<section class="px-margin-mobile pb-margin-mobile">
<div class="mb-6">
<!-- Activity Header -->
<div class="flex items-center gap-2 mb-3 px-1">
<div class="w-8 h-8 rounded-full bg-secondary-container text-on-secondary-container flex items-center justify-center shrink-0">
<span class="material-symbols-outlined text-[18px]">agriculture</span>
</div>
<h3 class="font-label-md text-on-surface-variant font-bold uppercase tracking-wider">Capacitación / Cos. De Arándano</h3>
</div>
<!-- Workers List -->
<div class="bg-surface-container-lowest rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.03)] overflow-hidden">
<!-- Worker 1 -->
<div class="flex items-center justify-between p-sm hover:bg-surface-container-low transition-colors cursor-pointer relative after:content-[''] after:absolute after:bottom-0 after:left-12 after:right-4 after:h-[1px] after:bg-surface-variant last:after:hidden">
<div class="flex items-center gap-3">
<div class="w-10 h-10 rounded-full bg-tertiary-fixed text-on-tertiary-fixed flex items-center justify-center font-title-md font-bold shrink-0">
                JC
              </div>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Juan Carlos Mamani</span>
<span class="font-label-sm text-on-surface-variant">DNI: 45829102</span>
</div>
</div>
<div class="bg-primary-container text-on-primary-container px-3 py-1 rounded-full font-label-md">
              1:00
            </div>
</div>
<!-- Worker 2 -->
<div class="flex items-center justify-between p-sm hover:bg-surface-container-low transition-colors cursor-pointer relative after:content-[''] after:absolute after:bottom-0 after:left-12 after:right-4 after:h-[1px] after:bg-surface-variant last:after:hidden">
<div class="flex items-center gap-3">
<div class="w-10 h-10 rounded-full bg-tertiary-fixed text-on-tertiary-fixed flex items-center justify-center font-title-md font-bold shrink-0">
                MR
              </div>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Maria Rodriguez Salinas</span>
<span class="font-label-sm text-on-surface-variant">DNI: 71293011</span>
</div>
</div>
<div class="bg-primary-container text-on-primary-container px-3 py-1 rounded-full font-label-md">
              1:00
            </div>
</div>
<!-- Worker 3 -->
<div class="flex items-center justify-between p-sm hover:bg-surface-container-low transition-colors cursor-pointer relative after:content-[''] after:absolute after:bottom-0 after:left-12 after:right-4 after:h-[1px] after:bg-surface-variant last:after:hidden">
<div class="flex items-center gap-3">
<div class="w-10 h-10 rounded-full bg-tertiary-fixed text-on-tertiary-fixed flex items-center justify-center font-title-md font-bold shrink-0">
                LP
              </div>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Luis Perez Gomez</span>
<span class="font-label-sm text-on-surface-variant">DNI: 40992837</span>
</div>
</div>
<div class="bg-primary-container text-on-primary-container px-3 py-1 rounded-full font-label-md">
              1:00
            </div>
</div>
<!-- Worker 4 -->
<div class="flex items-center justify-between p-sm hover:bg-surface-container-low transition-colors cursor-pointer relative after:content-[''] after:absolute after:bottom-0 after:left-12 after:right-4 after:h-[1px] after:bg-surface-variant last:after:hidden">
<div class="flex items-center gap-3">
<div class="w-10 h-10 rounded-full bg-tertiary-fixed text-on-tertiary-fixed flex items-center justify-center font-title-md font-bold shrink-0">
                AT
              </div>
<div class="flex flex-col">
<span class="font-body-md text-on-surface">Ana Torres Vera</span>
<span class="font-label-sm text-on-surface-variant">DNI: 44102938</span>
</div>
</div>
<div class="bg-primary-container text-on-primary-container px-3 py-1 rounded-full font-label-md">
              1:00
            </div>
</div>
</div>
</div>
<!-- Empty State for another potential activity -->
<div class="mt-8 flex flex-col items-center justify-center text-center p-6 bg-surface-container-lowest rounded-xl shadow-[0_2px_8px_rgba(0,0,0,0.02)] border border-dashed border-outline-variant">
<span class="material-symbols-outlined text-outline text-[40px] mb-2">add_task</span>
<h4 class="font-title-md text-on-surface mb-1">Añadir otra labor</h4>
<p class="font-body-md text-on-surface-variant max-w-[200px]">Registra nuevas actividades para esta parcela.</p>
<button class="mt-4 bg-secondary text-on-secondary px-6 py-2 rounded-full font-label-md hover:bg-primary transition-colors shadow-sm hover:shadow-md">
           Agregar Labor
         </button>
</div>
</section>
</div>
<!-- Bottom Navigation Tab Bar -->
<nav class="fixed bottom-0 left-0 right-0 bg-surface-container-lowest shadow-[0_-4px_16px_rgba(0,0,0,0.05)] pb-safe z-20">
<div class="flex justify-around items-center h-[64px]">
<!-- Tareo -->
<button class="flex flex-col items-center justify-center w-full h-full text-on-surface-variant hover:text-primary transition-colors group">
<div class="px-5 py-1 rounded-full group-hover:bg-primary-fixed/20 transition-colors mb-1">
<span class="material-symbols-outlined">edit_document</span>
</div>
<span class="font-label-sm">Tareo</span>
</button>
<!-- Productividad -->
<button class="flex flex-col items-center justify-center w-full h-full text-on-surface-variant hover:text-primary transition-colors group">
<div class="px-5 py-1 rounded-full group-hover:bg-primary-fixed/20 transition-colors mb-1">
<span class="material-symbols-outlined">monitoring</span>
</div>
<span class="font-label-sm">Productividad</span>
</button>
<!-- Resumen (Active) -->
<button class="flex flex-col items-center justify-center w-full h-full text-primary group">
<div class="px-5 py-1 rounded-full bg-primary-fixed mb-1 text-on-primary-fixed">
<span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">view_list</span>
</div>
<span class="font-label-sm font-bold">Resumen</span>
</button>
</div>
</nav>
</div></main></body></html>
<!DOCTYPE html>

<html lang="en"><head><meta charset="utf-8"/><meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover" name="viewport"/><link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/><link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/><script src="https://cdn.tailwindcss.com"></script><script id="tailwind-config">tailwind.config = { darkMode: "class", theme: { extend: { "colors": { "on-surface": "#191c1d", "primary-container": "#1b4332", "background": "#f8f9fa", "secondary": "#006c48", "primary-fixed": "#c1ecd4", "surface-container-highest": "#e1e3e4", "tertiary": "#3d1e07", "on-secondary-fixed": "#002113", "primary-fixed-dim": "#a5d0b9", "on-primary": "#ffffff", "secondary-container": "#92f7c3", "on-tertiary-fixed-variant": "#643e24", "secondary-fixed-dim": "#75daa8", "on-tertiary-fixed": "#301401", "on-primary-fixed": "#002114", "on-secondary-container": "#00734d", "tertiary-fixed": "#ffdcc7", "on-tertiary": "#ffffff", "surface-container-lowest": "#ffffff", "inverse-surface": "#2e3132", "surface-container-low": "#f3f4f5", "error-container": "#ffdad6", "outline-variant": "#c1c8c2", "on-error": "#ffffff", "on-primary-fixed-variant": "#274e3d", "surface": "#f8f9fa", "on-error-container": "#93000a", "surface-tint": "#3f6653", "inverse-on-surface": "#f0f1f2", "error": "#ba1a1a", "on-primary-container": "#86af99", "tertiary-fixed-dim": "#f2bb98", "surface-dim": "#d9dadb", "surface-variant": "#e1e3e4", "surface-bright": "#f8f9fa", "on-tertiary-container": "#cf9b7a", "primary": "#012d1d", "on-surface-variant": "#414844", "secondary-fixed": "#92f7c3", "on-background": "#191c1d", "on-secondary": "#ffffff", "on-secondary-fixed-variant": "#005235", "inverse-primary": "#a5d0b9", "surface-container-high": "#e7e8e9", "surface-container": "#edeeef", "outline": "#717973", "tertiary-container": "#57331a" }, "borderRadius": { "DEFAULT": "0.25rem", "lg": "0.5rem", "xl": "0.75rem", "full": "9999px" }, "spacing": { "sm": "12px", "base": "8px", "lg": "24px", "margin-mobile": "16px", "xl": "40px", "gutter": "16px", "xs": "4px", "margin-desktop": "32px", "md": "16px" }, "fontFamily": { "body-md": ["Inter"], "label-sm": ["Inter"], "headline-lg-mobile": ["Inter"], "body-lg": ["Inter"], "headline-lg": ["Inter"], "display-lg": ["Inter"], "label-md": ["Inter"], "title-md": ["Inter"] }, "fontSize": { "body-md": ["16px", { "lineHeight": "24px", "fontWeight": "400" }], "label-sm": ["12px", { "lineHeight": "16px", "letterSpacing": "0.05em", "fontWeight": "600" }], "headline-lg-mobile": ["24px", { "lineHeight": "32px", "fontWeight": "600" }], "body-lg": ["18px", { "lineHeight": "28px", "fontWeight": "400" }], "headline-lg": ["32px", { "lineHeight": "40px", "fontWeight": "600" }], "display-lg": ["48px", { "lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700" }], "label-md": ["14px", { "lineHeight": "20px", "letterSpacing": "0.01em", "fontWeight": "500" }], "title-md": ["20px", { "lineHeight": "28px", "fontWeight": "600" }] } } } };</script><style>@layer base { body { -webkit-tap-highlight-color: transparent; overscroll-behavior-y: contain; } .pt-safe { padding-top: env(safe-area-inset-top, 0px); } .pb-safe { padding-bottom: env(safe-area-inset-bottom, 0px); } } .sidebar-transition { transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1); }</style><style>
    body {
      min-height: max(884px, 100dvh);
    }
  </style>
</head><body class="bg-black font-body-md text-on-background"><header class="fixed top-0 w-full z-50 bg-[#1b4332] text-white shadow-md pt-safe"><div class="h-16 px-margin-mobile flex items-center gap-md"><button class="w-11 h-11 flex items-center justify-center rounded-full active:bg-white/10 transition-colors"><span class="material-symbols-outlined text-white">arrow_back</span></button><span class="font-title-md text-title-md text-white">Escanear QR</span></div></header><main class="flex flex-col relative w-full h-[100dvh] overflow-hidden bg-black text-white pt-16">
<!-- Scanner Overlay -->
<div class="absolute inset-0 z-10 flex flex-col pt-16">
<!-- Top Darkened Area -->
<div class="flex-1 bg-black/60 backdrop-blur-[2px]"></div>
<!-- Middle Scanning Row -->
<div class="flex flex-row">
<!-- Left Darkened Area -->
<div class="flex-1 bg-black/60 backdrop-blur-[2px]"></div>
<!-- Clear Scanning Bracket -->
<div class="w-[280px] h-[280px] relative shrink-0 rounded-lg">
<!-- Corner Brackets -->
<div class="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-secondary-container rounded-tl-lg"></div>
<div class="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-secondary-container rounded-tr-lg"></div>
<div class="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-secondary-container rounded-bl-lg"></div>
<div class="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-secondary-container rounded-br-lg"></div>
<!-- Animated Scanning Line -->
<div class="absolute top-0 left-0 right-0 h-0.5 bg-secondary-container/80 shadow-[0_0_8px_2px_rgba(146,247,195,0.6)] animate-[scan_2.5s_ease-in-out_infinite]"></div>
</div>
<!-- Right Darkened Area -->
<div class="flex-1 bg-black/60 backdrop-blur-[2px]"></div>
</div>
<!-- Bottom Darkened Area with Actions -->
<div class="flex-1 bg-black/60 backdrop-blur-[2px] flex flex-col pt-lg px-margin-mobile pb-[env(safe-area-inset-bottom,24px)] gap-lg">
<p class="text-body-md text-center text-white/90 font-medium mb-auto">
          Apunta al código QR del trabajador
        </p>
<!-- Controls -->
<div class="flex justify-center gap-xl mb-md">
<!-- Flashlight Toggle -->
<button class="flex flex-col items-center gap-xs text-white/80 transition-colors active:text-secondary-container" id="torch-btn" onclick="this.classList.toggle('text-secondary-container'); this.classList.toggle('text-white/80')">
<div class="w-14 h-14 rounded-full bg-white/15 flex items-center justify-center backdrop-blur-md active:bg-white/25 transition-colors">
<span class="material-symbols-outlined text-[28px]">flashlight_on</span>
</div>
<span class="font-label-sm">Linterna</span>
</button>
</div>
<!-- Manual Entry -->
<button class="w-full bg-white/15 hover:bg-white/20 active:bg-white/25 backdrop-blur-md text-white font-label-md py-4 rounded-xl flex items-center justify-center gap-sm transition-colors mb-4">
<span class="material-symbols-outlined text-[20px]">keyboard</span>
        Ingresar código manualmente
      </button>
</div>
</div>
<!-- Simulated Camera Feed Background -->
<div class="absolute inset-0 z-0 bg-cover bg-center" data-alt="A slightly blurred, first-person view looking down at a clipboard with an identification badge lying on top of it, outdoors in a bright, sunlit agricultural field with rows of green crops visible in the out-of-focus background. The lighting is harsh natural daylight, creating strong shadows. The perspective simulates looking through a smartphone camera." style="background-image: url('https://lh3.googleusercontent.com/aida-public/AB6AXuCFei155CBNzpS06-k_bvIlNWtbEUoBKtJnvyI9Orkx1bAC0OujMXll3zxUO-8iF2Bne8P_NWwBv-dl5pqU95RIxE_Zc8E1zrYZlRyqfdYv5qcpymTFF4ODv8FRZzR6b2i12K3Nn8dKDZUCnzumfr71iAxiuwZkig9jaByMPvk7zq_cvbo5fLsmeIjDxwA2XKCR6ot8960KzlLSYqpi1GPq6oPie5LJBuH00wFqDbCKG4Qte4_gnPsnNA')">
<!-- Static noise overlay to make it look more like a live camera -->
<div class="absolute inset-0 opacity-10 mix-blend-overlay bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0IiBoZWlnaHQ9IjQiPgo8cmVjdCB3aWR0aD0iNCIgaGVpZ2h0PSI0IiBmaWxsPSIjZmZmIiBmaWxsLW9wYWNpdHk9IjAuMDUiLz4KPHBhdGggZD0iTTAgMGgxdjFIMEoiIGZpbGw9IiMwMDAiIGZpbGwtb3BhY2l0eT0iMC4xIi8+CjxwYXRoIGQ9Ik0yIDJoMXYxSDJ6IiBmaWxsPSIjMDAwIiBmaWxsLW9wYWNpdHk9IjAuMSIvPgo8L3N2Zz4=')]"></div>
</div>
<style>
    @keyframes scan {
      0% { top: 0; opacity: 0; }
      10% { opacity: 1; }
      90% { opacity: 1; }
      100% { top: 100%; opacity: 0; }
    }
  </style>
</main></body></html>
