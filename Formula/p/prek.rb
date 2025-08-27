class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "daf0a3831b5d4bc9cdce79acdc67b05b5d46376fc27be15f0df07c99b0ed3c4e"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9207a01bc7dff37b6edaf26f9c6324c5f3f354427181ae0f6a8993202d273a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41eed7a8f834db915cbbda00e5f2f9d6451dda30f80c9cf42fb16d1706529644"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6ef2fb9f91231a0fb34033cc81070e14ca4569f7463e348ff0beab914c6e224"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd56dc49fa0415dc03c5070bf48d419045697da8afaf63db11c4a4b81ca1215b"
    sha256 cellar: :any_skip_relocation, ventura:       "b78f00ea84c34131183bc5d1b99b0de838eea9b840a06e8131383ef63af8c09a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "774e48a82eca875e3e56698479293c1d5717a3b2f7bee3f7a709796537a69809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "101499ac67059b9178fd16236cf0125c9d14d69e3f429e392dbe7f9eba8e05db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end