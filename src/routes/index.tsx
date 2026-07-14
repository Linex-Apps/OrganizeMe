import { createFileRoute } from "@tanstack/react-router";

export const Route = createFileRoute("/")({
  component: Home,
});

const FEATURES = [
  {
    title: "Dashboard Overview",
    description:
      "Your home screen, beautifully organized. See your favorites, app categories, collections, and recently used apps all in one place.",
    image: "/images/feature-dashboard.png",
    imageAlt: "Dashboard screen showing organized app overview",
  },
  {
    title: "Smart Categories",
    description:
      "Apps are intelligently sorted into categories like Social, Productivity, Entertainment, Finance, and more. Each with color-coded icons.",
    image: "/images/feature-categories-new.png",
    imageAlt: "Smart categories view showing organized apps",
  },
  {
    title: "Instant Search",
    description:
      "Can't find an app? Just type. Search across all your apps instantly — no more swiping through pages.",
    image: "/images/feature-search-new.png",
    imageAlt: "Search interface showing fast app lookup",
  },
  {
    title: "Custom Collections",
    description:
      "Create your own collections for any purpose — Work Tools, Travel Essentials, Weekend Fun, you name it.",
    image: "/images/feature-collections-new.png",
    imageAlt: "Custom collections feature showing user-created app groups",
  },
];

const PRICING_TIERS = [
  {
    name: "Free",
    price: "$0",
    period: "forever",
    description: "Perfect for getting started",
    features: [
      "Full app scan & detection",
      "Smart auto-categories",
      "Instant search",
      "Favorites & bookmarks",
      "Up to 3 custom collections",
    ],
    cta: "Get Started Free",
    highlighted: false,
  },
  {
    name: "Premium",
    price: "$2.99",
    period: "/month",
    description: "For power organizers",
    features: [
      "Everything in Free",
      "Unlimited custom collections",
      "Custom icons & themes",
      "Cloud backup & sync",
      "Advanced usage stats",
      "Future AI features",
    ],
    cta: "Go Premium",
    highlighted: true,
  },
];

function Home() {
  return (
    <div className="min-h-dvh">
      {/* Navigation */}
      <nav className="fixed top-0 left-0 right-0 z-50 border-b border-gray-100 bg-white/80 backdrop-blur-md">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-2">
            <div className="flex h-8 w-8 items-center justify-center rounded-lg bg-gradient-to-br from-blue-600 to-yellow-400 text-sm font-bold text-white">
              O
            </div>
            <span className="text-lg font-bold text-gray-900">OrganizeMe</span>
          </div>
          <div className="hidden items-center gap-8 sm:flex">
            <a
              href="#features"
              className="text-sm font-medium text-gray-600 transition-colors hover:text-gray-900"
            >
              Features
            </a>
            <a
              href="#pricing"
              className="text-sm font-medium text-gray-600 transition-colors hover:text-gray-900"
            >
              Pricing
            </a>
          </div>
          <a
            href="#cta"
            className="rounded-full bg-blue-600 px-5 py-2 text-sm font-semibold text-white shadow-sm transition-all hover:bg-blue-700 hover:shadow-md"
          >
            Get Started
          </a>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-b from-white via-blue-50/40 to-white pt-32 pb-20 sm:pt-40 sm:pb-28">
        <div className="bg-grid-pattern pointer-events-none absolute inset-0" />
        <div className="pointer-events-none absolute -top-40 left-1/2 h-[600px] w-[600px] -translate-x-1/2 rounded-full bg-blue-400/10 blur-3xl" />
        <div className="mx-auto max-w-7xl px-6">
          <div className="mx-auto max-w-3xl text-center">
            <div className="mb-6 inline-flex items-center gap-2 rounded-full border border-blue-200 bg-blue-50 px-4 py-1.5 text-sm font-medium text-blue-700">
              <span className="flex h-2 w-2 rounded-full bg-blue-500" />
              Your apps, beautifully organized
            </div>
            <h1 className="text-4xl font-extrabold tracking-tight text-gray-900 sm:text-6xl lg:text-7xl">
              Your phone.
              <br />
              <span className="bg-gradient-to-r from-blue-600 to-yellow-400 bg-clip-text text-transparent">
                Finally organized.
              </span>
            </h1>
            <p className="mt-6 text-lg leading-relaxed text-gray-600 sm:text-xl">
              Stop searching through cluttered home screens. OrganizeMe turns your
              phone into a personalized app directory — every app findable in seconds.
            </p>
            <div className="mt-10 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
              <a
                href="#cta"
                className="inline-flex w-full items-center justify-center rounded-full bg-blue-600 px-8 py-3.5 text-base font-semibold text-white shadow-sm transition-all hover:bg-blue-700 hover:shadow-md sm:w-auto"
              >
                Start Organizing Free
              </a>
              <a
                href="#features"
                className="inline-flex w-full items-center justify-center rounded-full border border-gray-300 bg-white px-8 py-3.5 text-base font-semibold text-gray-700 transition-all hover:bg-gray-50 sm:w-auto"
              >
                See How It Works
              </a>
            </div>
          </div>
          <div className="mt-16 flex justify-center">
            <div className="relative">
              <div className="absolute -inset-4 rounded-3xl bg-gradient-to-r from-blue-500/20 to-yellow-500/20 blur-xl" />
              <img
                src="/images/hero-phone.png"
                alt="OrganizeMe app showing organized app directory on iPhone"
                className="relative w-full max-w-[280px] rounded-2xl shadow-2xl ring-1 ring-gray-900/10 sm:max-w-[320px]"
              />
            </div>
          </div>
          <div className="mt-16 grid grid-cols-2 gap-8 border-t border-gray-100 pt-10 sm:grid-cols-4">
            {[
              { value: "10k+", label: "Active Users" },
              { value: "50k+", label: "Apps Organized" },
              { value: "4.8★", label: "App Store Rating" },
              { value: "99%", label: "Scan Accuracy" },
            ].map((stat) => (
              <div key={stat.label} className="text-center">
                <div className="text-2xl font-bold text-gray-900 sm:text-3xl">
                  {stat.value}
                </div>
                <div className="mt-1 text-sm text-gray-500">{stat.label}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-20 sm:py-28">
        <div className="mx-auto max-w-7xl px-6">
          <div className="mx-auto max-w-2xl text-center">
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
              Everything you need to tame your home screen
            </h2>
            <p className="mt-4 text-lg text-gray-600">
              OrganizeMe gives you the tools to finally bring order to your apps.
            </p>
          </div>
          <div className="mt-16 grid gap-12 sm:gap-16">
            {FEATURES.map((feature, index) => (
              <div
                key={feature.title}
                className={`flex flex-col items-center gap-8 ${
                  index % 2 === 0 ? "lg:flex-row" : "lg:flex-row-reverse"
                }`}
              >
                <div className="flex-1">
                  <div className="inline-flex h-12 w-12 items-center justify-center rounded-xl bg-blue-100 text-blue-600">
                    <span className="text-lg font-bold">{index + 1}</span>
                  </div>
                  <h3 className="mt-4 text-2xl font-bold text-gray-900">
                    {feature.title}
                  </h3>
                  <p className="mt-3 max-w-md text-lg leading-relaxed text-gray-600">
                    {feature.description}
                  </p>
                </div>
                <div className="flex-1">
                  <div className="relative mx-auto max-w-[260px]">
                    <div className="absolute -inset-2 rounded-2xl bg-gradient-to-br from-blue-100 to-yellow-100 opacity-60" />
                    <img
                      src={feature.image}
                      alt={feature.imageAlt}
                      className="relative w-full rounded-xl shadow-lg ring-1 ring-gray-900/5"
                    />
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Pricing Section */}
      <section id="pricing" className="bg-gray-50 py-20 sm:py-28">
        <div className="mx-auto max-w-7xl px-6">
          <div className="mx-auto max-w-2xl text-center">
            <h2 className="text-3xl font-bold tracking-tight text-gray-900 sm:text-4xl">
              Simple, transparent pricing
            </h2>
            <p className="mt-4 text-lg text-gray-600">
              Start free, upgrade when you need more power.
            </p>
          </div>
          <div className="mt-16 grid gap-8 lg:grid-cols-2 lg:gap-12">
            {PRICING_TIERS.map((tier) => (
              <div
                key={tier.name}
                className={`relative rounded-2xl border p-8 shadow-sm ${
                  tier.highlighted
                    ? "border-blue-200 bg-white shadow-blue-100/50 ring-2 ring-blue-600"
                    : "border-gray-200 bg-white"
                }`}
              >
                {tier.highlighted && (
                  <div className="absolute -top-3 left-1/2 -translate-x-1/2">
                    <span className="inline-flex items-center rounded-full bg-blue-600 px-4 py-1 text-xs font-semibold text-white">
                      Most Popular
                    </span>
                  </div>
                )}
                <div className="text-center">
                  <h3 className="text-lg font-semibold text-gray-900">
                    {tier.name}
                  </h3>
                  <div className="mt-4 flex items-baseline justify-center gap-1">
                    <span className="text-5xl font-extrabold tracking-tight text-gray-900">
                      {tier.price}
                    </span>
                    <span className="text-sm text-gray-500">{tier.period}</span>
                  </div>
                  <p className="mt-2 text-sm text-gray-500">{tier.description}</p>
                </div>
                <ul className="mt-8 space-y-4">
                  {tier.features.map((feature) => (
                    <li key={feature} className="flex items-start gap-3">
                      <svg
                        className={`h-5 w-5 flex-shrink-0 ${
                          tier.highlighted ? "text-blue-600" : "text-yellow-500"
                        }`}
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          strokeLinecap="round"
                          strokeLinejoin="round"
                          strokeWidth={2.5}
                          d="M5 13l4 4L19 7"
                        />
                      </svg>
                      <span className="text-sm text-gray-600">{feature}</span>
                    </li>
                  ))}
                </ul>
                <div className="mt-8">
                  <a
                    href="#cta"
                    className={`flex w-full items-center justify-center rounded-full px-6 py-3 text-base font-semibold shadow-sm transition-all ${
                      tier.highlighted
                        ? "bg-blue-600 text-white hover:bg-blue-700 hover:shadow-md"
                        : "border border-blue-200 bg-white text-blue-700 hover:bg-blue-50"
                    }`}
                  >
                    {tier.cta}
                  </a>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section
        id="cta"
        className="relative overflow-hidden bg-gradient-to-br from-blue-600 to-blue-800 py-20 sm:py-28"
      >
        <div className="pointer-events-none absolute -right-40 -top-40 h-[500px] w-[500px] rounded-full bg-blue-400/20 blur-3xl" />
        <div className="pointer-events-none absolute -bottom-40 -left-40 h-[400px] w-[400px] rounded-full bg-yellow-400/15 blur-3xl" />
        <div className="mx-auto max-w-7xl px-6">
          <div className="mx-auto max-w-2xl text-center">
            <h2 className="text-3xl font-bold tracking-tight text-white sm:text-4xl">
              Ready to organize your phone?
            </h2>
            <p className="mt-4 text-lg leading-relaxed text-blue-100">
              Join thousands of users who have transformed their cluttered home
              screens into beautiful, organized app directories.
            </p>
            <div className="mt-10 flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
              <a
                href="#"
                className="inline-flex w-full items-center justify-center rounded-full bg-white px-8 py-3.5 text-base font-semibold text-blue-700 shadow-sm transition-all hover:bg-blue-50 hover:shadow-md sm:w-auto"
              >
                Download for iOS
              </a>
              <a
                href="#"
                className="inline-flex w-full items-center justify-center rounded-full border border-blue-400 bg-blue-500/20 px-8 py-3.5 text-base font-semibold text-white backdrop-blur-sm transition-all hover:bg-blue-500/30 sm:w-auto"
              >
                Download for Android
              </a>
            </div>
            <p className="mt-6 text-sm text-blue-200">
              Free to start. No credit card required.
            </p>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-gray-100 bg-white py-12">
        <div className="mx-auto max-w-7xl px-6">
          <div className="flex flex-col items-center justify-between gap-6 sm:flex-row">
            <div className="flex items-center gap-2">
              <div className="flex h-7 w-7 items-center justify-center rounded-lg bg-gradient-to-br from-blue-600 to-yellow-400 text-xs font-bold text-white">
                O
              </div>
              <span className="text-sm font-semibold text-gray-900">OrganizeMe</span>
            </div>
            <div className="flex items-center gap-6">
              <a
                href="#features"
                className="text-sm text-gray-500 transition-colors hover:text-gray-900"
              >
                Features
              </a>
              <a
                href="#pricing"
                className="text-sm text-gray-500 transition-colors hover:text-gray-900"
              >
                Pricing
              </a>
              <a
                href="#"
                className="text-sm text-gray-500 transition-colors hover:text-gray-900"
              >
                Privacy
              </a>
              <a
                href="#"
                className="text-sm text-gray-500 transition-colors hover:text-gray-900"
              >
                Contact
              </a>
            </div>
            <p className="text-sm text-gray-400">
              &copy; {new Date().getFullYear()} OrganizeMe. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
