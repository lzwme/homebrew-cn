class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.38.0",
      revision: "821fc0eaa7c07fc98df1e9d3d43371cace697644"
  license "MIT"
  revision 1
  compatibility_version 1
  head "https://github.com/jpsim/SourceKitten.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3337c29f17e677b3c60125357245a07f38745675cff992c0f7d4f611937bc255"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c212e9aea3bae0aad47f3cb0b1cc9f963587a343a5756b91bb10aedb1be0e47e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01cc198a6d008ef342bb28aa150c3a979b9b9fa7e6012b06537aa774b9af76ea"
    sha256                               arm64_linux:       "538bc5d8707398b80bc38a7bdc44cfd4d9ec06748dd4d0d1f3bd7bb4d02aaaad"
    sha256                               x86_64_linux:      "59838ce768d30216221fb2b958e4429e93b9dce0ea8d7f2c57d62f8f944de34a"
  end

  uses_from_macos "swift"

  on_macos do
    depends_on xcode: ["14.0", :build]
    depends_on xcode: "6.0" # does not support CLT sourcekitd.framework
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
    generate_completions_from_executable(bin/"sourcekitten", "--generate-completion-script")
  end

  test do
    system bin/"sourcekitten", "version"
    return if OS.mac? && MacOS::Xcode.version < 14

    ENV["IN_PROCESS_SOURCEKIT"] = "YES"
    system bin/"sourcekitten", "syntax", "--text", "import Foundation // Hello World"
  end
end