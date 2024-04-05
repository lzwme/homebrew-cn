class Gptscript < Formula
  desc "Develop LLM Apps in Natural Language"
  homepage "https:gptscript.ai"
  url "https:github.comgptscript-aigptscriptarchiverefstagsv0.4.1.tar.gz"
  sha256 "53416335afe83f07713f2939aec3007104ac3b43235d1ac1b97a5d980fceab58"
  license "Apache-2.0"
  head "https:github.comgptscript-aigptscript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e33006d561ae88e74aef0fd3904a30933546e723387f3d343a3b33778140c86d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cc52cb54f38ea5348eb1acb2dd6fcae948d6e17e415942f8c80ce18fe22d5c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3958790a61b663f8795e3ac2762409f313a108c1b514f3b16113104743014689"
    sha256 cellar: :any_skip_relocation, sonoma:         "86a330b7cb7c9e36cded6c10ef253c50edb53bd8e0cb73d8a374666b671174a2"
    sha256 cellar: :any_skip_relocation, ventura:        "1fd7ed39f70aee7632a0b240d9fa68d8a89e6b6307c8c367361918c864186063"
    sha256 cellar: :any_skip_relocation, monterey:       "364a5b2dc5259ab40dc3ccef3da4cfe4aa8f38d17df88ad6135ac16fd9dd6237"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04d609cfdc56d60a45dfc31dfd80837f9478785cc07eca700ee9009f3bc1f53a"
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