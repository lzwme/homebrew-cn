class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.8.3.tar.gz"
  sha256 "bb2eb60f763e891d2d438cfec68ddab5421169380685c9a8ab7c2cf2bd1bf6d5"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "48f5f071952cfc44762c34f977ad90f71a4b9b4f835cea8ae634e059e95d6cf7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0a74834111e30a46e492007ba6a1791d0cd65a5d2a329688a769a75c0da99bf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "985e74bbd70e207744c3206b76f79d4ccd2650b20f37293039421de0ce2bf280"
    sha256 cellar: :any_skip_relocation, sonoma:         "e403727d856b88f10e408a1834d89d0622ad7e87fadcdce454da78da9f5bf16e"
    sha256 cellar: :any_skip_relocation, ventura:        "36cc92ccb3c84d410f7bbf6f0ea1ba385af39e581abca472932699cb5fe4618b"
    sha256 cellar: :any_skip_relocation, monterey:       "08f00f30ca94fcba6e480b2565f92d533abfb9d6dcf1ff5740de68ee6b430845"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be01ee67f4c15aa7f3bb71b81e932855fdc0b0f67b923e49cf8200117af0c68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgptscript-aigptscriptpkgversion.Tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin"gptscript -v")

    output = shell_output(bin"gptscript #{pkgshare}examplesbob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end