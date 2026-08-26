class ProtonPassCli < Formula
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"
  url "https://ghfast.top/https://github.com/protonpass/pass-cli/archive/refs/tags/2.3.3.tar.gz"
  sha256 "a064b89fc4fb5d2db47a99e46e1782b7672dc1078e2ecbb881d0910c01947611"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7578f2ca2d0f263ab7b361d18a5859ff0df7aa2fcd2b44b59f283f1d6a385ca7"
    sha256 cellar: :any, arm64_sequoia: "eae98cc909a9c68a05720dc53d287eec92ef241cb93df26b8c47fb75b7367696"
    sha256 cellar: :any, arm64_sonoma:  "7c223fff651acee33bd3b45721748857a424ee4e25e748116f1b44b5883d17b2"
    sha256 cellar: :any, sonoma:        "21cf3b64c173ed3632ac238564a1c8857ddafb62585b31dc90f5de9ccfa2615f"
    sha256 cellar: :any, arm64_linux:   "8e4ed9615dff6a43ec79f6fa2fb9af170b710fff8b825aa73e1cb18c38e4bbbb"
    sha256 cellar: :any, x86_64_linux:  "f18d354f99416626bce13f1911b36730e804eba7fc38f8f963a17b867572ee85"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  # Upstream does not currently accept external contributions.
  # Increase the recursion limit required to compile pass-cli 2.3.3.
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args(path: "pass-cli")
    generate_completions_from_executable(bin/"pass-cli", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pass-cli --version")
    assert_match "Successful", shell_output("#{bin}/pass-cli logout --force")

    # Most operations require an authenticated session or keyring access.
    ENV["PROTON_PASS_KEY_PROVIDER"] = "fs"
    output_log = testpath/"output.log"
    pid = spawn bin/"pass-cli", "login", [:out, :err] => output_log.to_s
    sleep 5
    assert_match "Waiting for authentication to complete", output_log.read
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/pass-cli/src/main.rs b/pass-cli/src/main.rs
index 43cff31..55c8597 100644
--- a/pass-cli/src/main.rs
+++ b/pass-cli/src/main.rs
@@ -1,3 +1,4 @@
+#![recursion_limit = "256"]
 /*
  *  Copyright (c) 2026 Proton AG
  *  This file is part of Proton AG and Proton Pass.