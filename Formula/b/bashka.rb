class Bashka < Formula
  desc "Static verification of installation bash scripts"
  homepage "https://github.com/dmtrKovalenko/bashka"
  url "https://ghfast.top/https://github.com/dmtrKovalenko/bashka/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d25f80f00132287cd2c32d880848fffa14c648c838f3bd5bbd4b47e06f471200"
  license "MIT"
  head "https://github.com/dmtrKovalenko/bashka.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "48be3cabd5244838d0883f2b2001e8b9b9561225682da1d8fa11967a34d90565"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b2f746906f443831d167d208fdb8ea1b72c6a3404a3707d90f3f7b7c2cef8789"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "879d12f1d666102fa653d467f2253f57ea6c7ffd63a8d3f60e78ee7b72668a2f"
    sha256 cellar: :any,                 arm64_linux:       "2d79cd28ccb42ef0f805652c0cc5c642ec1a6875762ef745b2259369541e0a7b"
    sha256 cellar: :any,                 x86_64_linux:      "cf26f4ff4b1603a8407e1c011c619f3c751e3e9a0859c8874c04fed9c096d96c"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bashka --version")

    malicious = <<~BASH
      #!/usr/bin/env bash

      rm -rf /
    BASH
    empty = <<~BASH
      #!/usr/bin/env bash

      echo Hi
    BASH

    # Couldn't capture `stderr` for some reason (`2>&1` and `open3` methods didn't work).
    # Don't match output, just check the exit codes
    pipe_output("#{bin}/bashka --check", malicious, 3)
    pipe_output("#{bin}/bashka --check", empty, 1)
  end
end