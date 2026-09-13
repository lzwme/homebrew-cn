class DartSdk < Formula
  desc "Dart Language SDK, including the VM, dart2js, core libraries, and more"
  homepage "https://dart.dev"
  url "https://ghfast.top/https://github.com/dart-lang/sdk/archive/refs/tags/3.13.3.tar.gz"
  sha256 "9320d014e0be89d486f383575d2efcf61d6c948f91338b1da7faf79680a1a3b0"
  license "BSD-3-Clause"
  compatibility_version 3

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "2365c809941d6109515a57e159bb04e87731b2cfa66f8df63e9be8ab89d97fcb"
    sha256 cellar: :any, arm64_tahoe:       "7cd76ba93860224ab2123ce4a9dfae1f3a3316200b13b7dc7ce632ecd3a76a76"
    sha256 cellar: :any, arm64_sequoia:     "eb5e1ca53d61f6658686481ceac5ff268188412e7aeb9e689bc7e3a980c6f1f8"
    sha256 cellar: :any, arm64_linux:       "ba5908e47e7df690fc51b9060e01974b3a3493498b9833a29ff7d54512c2a398"
    sha256 cellar: :any, x86_64_linux:      "fbcb4ca31cd1bbcbd65b816becb4bcee41bdd8d5ecc4c58e28ed1653a33630d0"
  end

  depends_on "ninja" => :build
  depends_on "rust" => :build

  uses_from_macos "curl" => :build
  uses_from_macos "python" => :build
  uses_from_macos "xz" => :build

  # always pull the latest commit from https://chromium.googlesource.com/chromium/tools/depot_tools.git/+/refs/heads/main
  resource "depot-tools" do
    url "https://chromium.googlesource.com/chromium/tools/depot_tools.git",
        revision: "cb70c994a656601dc6a0d423f49ff57503bd70bc"
    version "cb70c994a656601dc6a0d423f49ff57503bd70bc"

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