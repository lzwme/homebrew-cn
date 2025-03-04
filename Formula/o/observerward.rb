class Observerward < Formula
  desc "Web application and service fingerprint identification tool"
  homepage "https:emo-crab.github.ioobserver_ward"
  url "https:github.comemo-crabobserver_wardarchiverefstagsv2025.3.3.tar.gz"
  sha256 "382fade85c16464f9135ccc1bb1daccee8a16cd69818a21a3e6b5474964cdd82"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c401dec7dca5407da20c122458cbcea8a8b92862ee1310783d8503601aa1d224"
    sha256 cellar: :any,                 arm64_sonoma:  "c3989e1b4991cb1c8a99121bb89a9c8f20db13cee82b8e7db65f11d10779feca"
    sha256 cellar: :any,                 arm64_ventura: "4b738cc306be1ca64405932b5aeb4a80105db5464f9f3fb396936d6e1dcd298c"
    sha256 cellar: :any,                 sonoma:        "640f640385535222de1215ade4372817c43aea4de52d97034433950497a804e3"
    sha256 cellar: :any,                 ventura:       "08d80c52700f6c03f98aab4e1b8680aa76ce56cddb08c6cef2f9e24265fc135f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "801c0e8486d7deacb402507848cf17ba8573d2730efea0dbbf44cdea70f5cbed"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "observer_ward")
  end

  test do
    require "utilslinkage"

    system bin"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}observer_ward -t https:www.example.com")

    [
      Formula["openssl@3"].opt_libshared_library("libcrypto"),
      Formula["openssl@3"].opt_libshared_library("libssl"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end