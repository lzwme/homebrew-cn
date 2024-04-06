class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.4.2.tar.gz"
  sha256 "db6dd34885a97b27967e61a5041846122d45fb333d9e565e4b326d4de8f4542a"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32293f804c06e39d583e5951426b76cb72ee2278d989ba18c8b60d0647051ae9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6fb4bb16184af571f0fe85a71fbe466134dfa7a0ce196c4fb2462ab40f75852e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa18ed36a0d8abcb015ed7edc29c97daec4e2023ef26e4572b967ad3d445957d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ddb8b16fe724e455e648f306281bdf2b9c44934a83dbae922400a8df0da2b88f"
    sha256 cellar: :any_skip_relocation, ventura:        "e9ec70de9cf36d1b0d48abb10ccb3f5e76cd399a99d2c81d6ccccb6d1c1307e9"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1d462b2de171182e91a01bd9b8b2d3e3a1b941936f03b8f8de047a6a2ae620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f04c442f8296b89444e4cc6f825ed5c6efdc7cdd186f546f4c7f43512deb3d1e"
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