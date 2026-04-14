class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "67fff81a1fac92afcaba5bb421a3a8ad6d6271b66825a0886e5c873816f790d7"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd11706237f10e9604c94c64e7677e340306b3b7a8ca2c6a92437c17f7fec338"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e814437e5e5cfb82cb453c68876cd35e112bd8333f4cb172950eb318bf3b1a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "64854cd402c95dd3cdb55c7aa955046261c42e1d4569522923c018b83178275a"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbdca7abeaf4df11fa6835f8b753c35903f4a4b288464918f6a14885e98fc4b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a40a3f73821a632ea39554ac585236a2c69111a935f2a4ef60e1c57a28603fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7acd3fa0efffb44a8e8a3077cc08197b70213b55da1217e1e1b7093a0385a31c"
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
    assert_match "See https://pre-commit.com for more information", output
  end
end