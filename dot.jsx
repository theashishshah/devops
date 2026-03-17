"use client";

import { useEffect, useState } from "react";
import { Check, Clock, Phone } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { ChevronDown } from "lucide-react";
import clsx from "clsx";
import { Mail } from "lucide-react";
import { useSearchParams } from "next/navigation";


    // const {
    //   name,
    //   email,
    //   phone,
    //   date,
    //   slot,
    //   source,
    // }: {
    //   name: string;
    //   email: string;
    //   phone: string;
    //   date: string;
    //   slot: string;
    //   source: string;
    // } = body;

const CATEGORIES = [
  { label: "Health Insurance", value: "Health Insurance" },
  { label: "Term Life Insurance", value: "Term Life Insurance" },
  { label: "Parent's Insurance", value: "Parent's Insurance" },
];

export default function BookingForm({
  canSubmit,
  date,
  slot,
  onSuccess,
}: Props) {
  const searchParams = useSearchParams();
  const [bookingState, setBookingState] = useState<BookingState>("idle");
  const [data, setData] = useState<any>(null);
  const [source, setSource] = useState<string>("website");
  useEffect(() => {
    const getSource = searchParams.get("source") || "website";
    console.log("Srouce: ", getSource);
    setSource(getSource);
  }, [searchParams]);

  const [categoryOpen, setCategoryOpen] = useState(false);
  const [category, setCategory] = useState(CATEGORIES[0]);

  async function submit(formData: FormData) {
    if (!canSubmit || bookingState === "processing") return;

    setBookingState("processing");
    const phoneRaw = formData.get("phone") as string;

    if (!/^[6-9]\d{9}$/.test(phoneRaw)) {
      setBookingState("error");
      return;
    }

    const phone = `+91${phoneRaw}`;

    const payload = {
      name: formData.get("name"),
      email: formData.get("email"),
      phone,
      category: formData.get("category"),
      date,
      slot,
      source,
    };

    try {
      const res = await fetch("/api/book", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-XSS-Protection": "1; mode=block",
          "X-Content-Type-Options": "nosniff",
          "Content-Security-Policy":
            "default-src 'self'; img-src 'self' data:; script-src 'self'; style-src 'self' 'unsafe-inline'",
          "Cache-Control": "no-store, no-cache, must-revalidate",
          "Referrer-Policy": "origin-when-cross-origin",
          "Feature-Policy": "microphone 'none'; camera 'none'",
          "Permissions-Policy": "microphone=(), camera=()",
          "Strict-Transport-Security":
            "max-age=63072000; includeSubDomains; preload",
        },
        body: JSON.stringify(payload),
      });

      if (!res.ok) throw new Error("Booking failed");

      setData(payload);
      // to show user that it is processing because it is not taking any time to book
      setTimeout(() => {
        setBookingState("success");
      }, 3000);
      onSuccess();
    } catch (error) {
      console.log("error");
      setBookingState("error");
    }
  }

  if (bookingState === "error") {
    return (
      <Card>
        <CardContent className="p-8 text-center space-y-4">
          <h2 className="text-lg font-semibold text-red-600">Booking failed</h2>
          <p className="text-sm text-slate-500">
            Something went wrong. Please try again.
          </p>
          <Button onClick={() => setBookingState("idle")}>Try again</Button>
        </CardContent>
      </Card>
    );
  }

  if (bookingState === "processing") {
    return (
      <Card className="border-slate-200 shadow-sm">
        <CardContent className="p-10 text-center space-y-6">
          <div className="mx-auto h-12 w-12 rounded-full border-4 border-[#5747c3]/20 border-t-[#5747c3] animate-spin" />

          <div>
            <h2 className="text-lg font-semibold text-slate-900">
              Booking your call…
            </h2>
            <p className="text-sm text-slate-500 mt-1">
              Please don&apos;t refresh or close this page
            </p>
          </div>
        </CardContent>
      </Card>
    );
  }

  if (bookingState === "success" && data) {
    return (
      <Card className="border-slate-200 shadow-sm">
        <CardContent className="p-8 space-y-6 text-center">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-green-50">
            <Check className="h-8 w-8 text-green-600" />
          </div>

          <div className="space-y-1">
            <h2 className="text-xl font-semibold text-slate-900">
              Booking confirmed
            </h2>
            <p className="text-sm text-slate-500">
              Confirmation email sent to{" "}
              <span className="font-medium text-slate-700">{data.email}</span>
            </p>
          </div>

          <Separator className="mb-2" />

          <div className="space-y-4 text-left text-sm text-slate-600">
            <div className="flex items-start gap-4">
              <Clock className="mt-0.5 h-4 w-4 text-slate-400" />
              <div>
                <p className="font-medium text-slate-900">
                  30 mins Free Consultation
                </p>
                {/* TODO: need to change this */}
                {/* <p className="text-slate-500">
                  {date && formatDate(date)} <br />
                  {slot && formatTimeRange(slot)} <br />
                  (GMT +05:30) India Standard Time
                </p> */}
                <div className="text-sm text-slate-500 text-left">
                  Your consultation has been successfully scheduled.
                </div>
              </div>
            </div>

            <div className="flex items-start gap-4">
              <Phone className="mt-0.5 h-4 w-4 text-slate-400" />
              <div>
                <p className="font-medium text-slate-900">Phone call</p>
                <p className="text-slate-500">
                  We&apos;ll call you at {data.phone}
                </p>
              </div>
            </div>
          </div>

          <Separator />

          {/* Footer actions */}
          <div className="space-y-3">
            <p className="text-sm text-slate-500">
              Need help or want to make changes?
            </p>

            <div className="flex flex-col items-center gap-1 text-sm text-slate-700">
              <div className="flex items-center gap-2">
                <Phone size={14} /> +91 99000 91495
              </div>
              <div className="flex items-center gap-2">
                <Mail size={14} /> hello@nyvo.in
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    );
  }

  return (
    <form action={submit} className="space-y-4">
      <h3 className="font-semibold text-slate-900 mb-2 text-base md:text-lg">
        Enter your details
      </h3>

      <input
        name="name"
        required
        placeholder="Full name"
        className="w-full rounded-lg border border-gray-200 p-3 md:p-3 text-sm md:text-base focus:outline-none focus:ring-1 focus:ring-gray-200"
      />

      <input
        name="email"
        type="email"
        required
        placeholder="Email"
        className="w-full rounded-lg border border-gray-200 p-3 md:p-3 text-sm md:text-base focus:outline-none focus:ring-1 focus:ring-gray-200"
      />

      <div className="flex rounded-lg border border-gray-200 overflow-hidden">
        <span className="flex items-center px-3 md:px-3 text-sm md:text-base bg-gray-50 text-gray-600">
          +91
        </span>

        <input
          name="phone"
          type="tel"
          inputMode="numeric"
          pattern="[0-9]{10}"
          maxLength={10}
          required
          placeholder="Enter 10-digit mobile number"
          className="flex-1 p-3 md:p-3 text-sm md:text-base focus:outline-none focus:ring-1 focus:ring-gray-200"
          onInput={(e) => {
            const input = e.currentTarget;
            input.value = input.value.replace(/\D/g, "").slice(0, 10);
          }}
        />
      </div>

      <div className="relative">
        <button
          type="button"
          onClick={() => setCategoryOpen((v) => !v)}
          className="
      cursor-pointer w-full rounded-lg border border-gray-200 bg-white
      p-3 md:p-3 pr-10 text-left text-sm md:text-base
      focus:outline-none
    "
        >
          {category.label}
          <ChevronDown
            size={16}
            className={clsx(
              "absolute right-3 md:right-4 top-1/2 -translate-y-1/2 transition",
              categoryOpen && "rotate-180",
            )}
          />
        </button>

        <input type="hidden" name="category" value={category.value} />
        {categoryOpen && (
          <ul className="absolute z-50 mt-1 w-full rounded-lg bg-white shadow-lg border border-gray-100">
            {CATEGORIES.map((opt) => (
              <li
                key={opt.value}
                onClick={() => {
                  setCategory(opt);
                  setCategoryOpen(false);
                }}
                className="
            cursor-pointer px-3 md:px-3 py-2 md:py-2.5 text-sm md:text-base
            transition-colors
            hover:bg-[#5747c3]/10
          "
              >
                {opt.label}
              </li>
            ))}
          </ul>
        )}
      </div>

      {!canSubmit && (
        <p className="text-sm md:text-base text-amber-600 bg-amber-50 px-3 md:px-4 py-2 md:py-2.5 rounded-lg">
          Please select a date and time slot to continue.
        </p>
      )}

      <button
        type="submit"
        disabled={!canSubmit}
        className={`
          w-full rounded-lg px-6 py-3.5 font-semibold text-sm md:text-base
          transition-all duration-200 ease-in-out
          focus:outline-none 
          ${
            !canSubmit
              ? "bg-slate-300 text-slate-500 cursor-not-allowed"
              : "bg-[#5747c3] text-white hover:bg-[#4638b3] active:bg-[#3d2fa3] shadow-sm hover:shadow-md cursor-pointer"
          }
        `}
      >
        Book a free call
      </button>

      <div className="space-y-4 pt-4">
        <div className="flex justify-center">
          <div className="inline-flex items-center gap-2 bg-indigo-50 rounded-full px-4 py-2.5 border border-indigo-100">
            <svg
              width="20"
              height="20"
              viewBox="0 0 24 24"
              fill="none"
              stroke="#6366F1"
              strokeWidth="2"
            >
              <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14" />
              <polyline points="22 4 12 14.01 9 11.01" />
            </svg>
            <span className="text-sm font-medium text-indigo-600">
              IRDAI Certified Advisor Will Assist You
            </span>
          </div>
        </div>

        <p className="text-center text-sm text-slate-500">
          No spam, only trusted advice
        </p>

        <div className="border-t border-slate-200 pt-4">
          <div className="flex justify-center items-center gap-6 text-sm text-slate-600">
            <div className="flex items-center gap-2">
              <Clock size={16} className="text-indigo-600" />
              <span>30 minutes</span>
            </div>
            <div className="flex items-center gap-2">
              <Phone size={16} className="text-indigo-600" />
              <span>Phone call</span>
            </div>
            <div className="flex items-center gap-2">
              <svg
                width="16"
                height="16"
                viewBox="0 0 24 24"
                fill="none"
                stroke="#6366F1"
                strokeWidth="2"
              >
                <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" />
              </svg>
              <span>100% Free</span>
            </div>
          </div>
        </div>
      </div>
    </form>
  );
}
