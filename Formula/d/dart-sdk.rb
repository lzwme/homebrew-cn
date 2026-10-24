class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.13.7.tar.gz"
  sha256 "cd2a1450f33cfeb35f180d33b836ab92a663d1335ee7f953ae3ebcb20308c99d"
  license "BSD-3-Clause"
  compatibility_version 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "95088584b90c2338619fad110494b7e44d1f9fe61cd3fdccb01f4c9677e82dfd"
    sha256 cellar: :any, arm64_tahoe:       "6ad0e27d397749539db7470ffd077d5f72733e101073942c9c027c769d4e0060"
    sha256 cellar: :any, arm64_sequoia:     "d325b40b927d9921f84a84591d42121f21b15ad1bfcb97c71e1174cd11654a27"
    sha256 cellar: :any, arm64_linux:       "30de9dac4b496d17ec3fb464c6f7f98d7195d29ff16605168e9dfe77f2b9de83"
    sha256 cellar: :any, x86_64_linux:      "410563acd62ab44dcc7bde97d33d4f88869e1e0381739d733bdb21dd9dc4d98e"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "b1c2e86792a7f2b6576c181b7327ddd53b1a42a8"
    version "b1c2e86792a7f2b6576c181b7327ddd53b1a42a8"

    livecheck do
      url "https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main?format=JSON"
      regex(/"commit":\s*"(\h+)"/i)
    end
  end

  def install
    resource("depot-tools").stage(buildpath/"depot-tools")

    ENV["DEPOT_TOOLS_UPDATE"] = "0"
    ENV.append_path "PATH", "#{buildpath}/depot-tools"

    # Roll clang to include lld support for arm64e.x1 targets in the macOS 27 SDK (llvm/llvm-project#222721)
    # TODO: Remove when upstream rolls clang past that commit, see https://github.com/dart-lang/sdk/issues/64264
    system "gclient", "config", "--name", "sdk",
           "--custom-var", 'clang_version="git_revision:07d67299a15ce03b053736e2d31a668ee0576987"',
           "https://dart.googlesource.com/sdk.git@#{version}"
    system "gclient", "sync", "--no-history"

    chdir "sdk" do
      # The newer clang flags an unused variable in binaryen, which is built with -Werror
      inreplace "third_party/binaryen/BUILD.gn", '"-Wno-unused-private-field",',
                                                   "\\0\n        \"-Wno-unused-variable\","

      arch = Hardware::CPU.arm? ? "arm64" : "x64"
      system "./tools/build.py", "--mode=release", "--arch=#{arch}", "create_sdk"
      out = OS.linux? ? "out" : "xcodebuild"
      libexec.install Dir["#{out}/Release#{arch.upcase}/dart-sdk/*"]
    end
    bin.install_symlink libexec/"bin/dart"
  end

  test do
    system bin/"dart", "create", "dart-test"
    chdir "dart-test" do
      assert_match "Hello world: 42!", shell_output("#{bin}/dart run")
    end
  end
end