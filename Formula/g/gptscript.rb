class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.9.2.tar.gz"
  sha256 "d0eafd87b503a193e47fc0b2fbe926b27fbaa871455ac318da67079f28ffc852"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "872e389dc19a9383d72c638954f1948533de5b0325747ad06dc1b4a883d54235"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75d358441d8304b71dfdaa96e508f8269f2e35f9e7a83395e6167f624e0ed12f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d01e1b0fe74517bd3aafdfe3a203fb95fbea706d4b79a2a1c5f7800015716e91"
    sha256 cellar: :any_skip_relocation, sonoma:         "74a0c9cf7752729ec56af0391b39c95b915a3b066ab5fbbab1fa374e2eeca17a"
    sha256 cellar: :any_skip_relocation, ventura:        "0e1df46aa0487df360902f4c319ffae88b16d9e31f7f3e28adfc5e8cd52678c8"
    sha256 cellar: :any_skip_relocation, monterey:       "d5459ef88997c2182d49d8dc2c427aa16e484ab6b9d271de0a83e5cb56490e29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9abc33c32ca0702cf1b238bb808a9d79c4f5f05dbfb5f82b3bcd267bd7ef87d0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgptscript-aigptscriptpkgversion.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "examples"
    generate_completions_from_executable(bin"gptscript", "completion")
  end

  test do
    ENV["OPENAI_API_KEY"] = "test"
    assert_match version.to_s, shell_output(bin"gptscript -v")

    output = shell_output(bin"gptscript #{pkgshare}examplesbob.gpt 2>&1", 1)
    assert_match "Incorrect API key provided", output
  end
end