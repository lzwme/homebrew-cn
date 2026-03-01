class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "b321bc99ac19dc1fd433cda433f11c36f6ce5174079d71fcebb471afc6aefd39"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16432ca87af13578655fc26e19e753b2b9c92b87198503484cb06f5dadbf3034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47efb034f76ad88a1ac7359355c781bdd424157eda87d2807184e98b197da245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05d498009d9b83a991c29453e0932db3695d10dd9312134cc63ae5f9566e2ddc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec22b5f822ad0be1ebfc16d53445494901eec3a3da686d5b198c9645d5710544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "704f89f3cb552d58d202b6a09ca7c6847a5b0667d4e6b3ad8b6324260e917cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34032cba76dd916358820902304dbc58dc35f765b0ad0ed903da71572a7153a1"
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