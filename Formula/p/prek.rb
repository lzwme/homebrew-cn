class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "3a19e696c7b06942947b8fd737c01a3ff0718a92460e59075828d43f80b6a814"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83a4c0219d0436fb1cf96097a83d2c2337c5b3d95badb115ba3ab055777bc432"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d59fffbb8e712206f81f285692748ce5f2fe8ef5a3ded92a7f137f73c58dc7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eefa9d56757f218eaeb1c7df52bd4182c9c16b477beeaf70e58b34130e90f534"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fa1ce8c4dadcc98891d7b63b6910eb7ce778ac251250201813d89f440ae5d9c"
    sha256 cellar: :any,                 arm64_linux:   "1900b1141894be4a37ca959bd4e5463fc1709bd6c1ee088315a26b44c11571d6"
    sha256 cellar: :any,                 x86_64_linux:  "45db70d267bcea12ad1f7d734227c57e59521c096b4d94020fd110df9454f72a"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://prek.j178.dev for more information", output
  end
end