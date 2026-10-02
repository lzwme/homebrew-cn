class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.13.5.tar.gz"
  sha256 "2da077bf89f3a14ae5a741728549371d87013265df49b8cace6475bd9ffc59e3"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ba2fe7dee081e6782d25e7b93c9b8856c03dadc6f199ae7cabc14a7889b3deee"
    sha256 cellar: :any, arm64_tahoe:       "ec74532ed9ee0061a7fdcf2b731f207bc9e095756a4d04ca921d1d52e0f40614"
    sha256 cellar: :any, arm64_sequoia:     "12bb228c9b6a2e7ddc89b2d4ae2102a425c2fad1930f44e38efcc3cdb43e360c"
    sha256 cellar: :any, arm64_linux:       "197fd010e58013ef62c8545f92d2e6dadab0792a298f23c71a8aac624f81f2df"
    sha256 cellar: :any, x86_64_linux:      "e32c710a32e233ce15ca8b144c28e68bf8032887cac7e81d59af30abeb40be85"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "b2042c50e4d8a0ecc69ebc60983024a5b477c4ca"
    version "b2042c50e4d8a0ecc69ebc60983024a5b477c4ca"

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