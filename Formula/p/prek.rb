class Prek < Formula
  desc "Fast Git hook manager written in Rust, drop-in alternative to pre-commit"
  homepage "https://prek.j178.dev/"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "c98edc2d545755b43a04097ad5f2eb69af30a7fea694d8163aa7a0128a166852"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "38e094c8586b0f69a0f39e48d0b817b9a5b259b395f8cb860d6c167ffc773f73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf983b4efe1c63c9ac7c30f0190f4ca5fda5633a15a3528c5966011ce082b011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c380255d1471669d2ec43f2eda3ed2ce49d15af0c6899bd94159be119ae6ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "93f65c62351fbb7bbdde9a9cf86b0848f6bfa28eb27799369718a8175b9413cb"
    sha256 cellar: :any,                 arm64_linux:   "a0d8d72af8d9415febf3159fdcd3bc9b356248937062cb10e61de51b243b86fb"
    sha256 cellar: :any,                 x86_64_linux:  "5b091284e215ebf0e4102dd3b293dc9667f35c26e032d97781cb23dbf8322ac4"
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