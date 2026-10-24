class Lispkit < Formula
  desc "Scheme framework for extension and scripting languages on macOS and iOS"
  homepage "https://lisppad.app"
  url "https://ghfast.top/https://github.com/objecthub/swift-lispkit/archive/refs/tags/2.6.3.tar.gz"
  sha256 "1265ed3249471888b2ad1284070833570dc8d56a374debd3b179362f58fa9771"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "40373c3455c3b3dce3f362baa4972869db8c7eab1ab4bccc19f6ccb64a5d9e9b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f3f5481d5a2e95103f03fc5c0d4125a5e7b289f457608b7bc80a59a42f74555f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "deed9bb30f7af9608faf160f21e3fe21514969b3032ed023b9cc116f52f7cff7"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    system "swift", "build", *std_swift_args
    libexec.install ".build/release/LispKitRepl"
    pkgshare.install Dir["Sources/LispKit/Resources/*"]
    (bin/"lispkit").write <<~BASH
      #!/bin/bash
      # LispKit REPL wrapper script
      RESOURCE_PATH="#{pkgshare}"
      # Check if user provided -r or --root flag
      HAS_ROOT=0
      for arg in "$@"; do
          if [[ "$arg" == "-r" ]] || [[ "$arg" == "--root" ]]; then
              HAS_ROOT=1
              break
          fi
      done
      # Execute with default resource path if not specified
      if [ $HAS_ROOT -eq 0 ]; then
          exec "#{libexec}/LispKitRepl" -r "$RESOURCE_PATH" "$@"
      else
          exec "#{libexec}/LispKitRepl" "$@"
      fi
    BASH
    chmod 0555, bin/"lispkit"
  end

  test do
    # Test that LispKit can evaluate a simple expression
    output = shell_output("#{bin}/lispkit -r \"#{pkgshare}\" -c \"\" -b -q 2>&1 <<< '(+ 1 2 3)'")
    assert_match "6", output
    reported = shell_output("#{bin}/lispkit -r \"#{pkgshare}\" -c \"\" -b -q 2>&1 <<< '(implementation-version)'")
    assert_match version.to_s, reported
  end
end