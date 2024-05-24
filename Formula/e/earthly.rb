class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.12",
      revision: "7dbb0eab6af95b6f43483ff4065445470252f522"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e3c3af5d566fdef096716c867aaa771d4cb0e5613d14edf0db627e8df2a430c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e3c3af5d566fdef096716c867aaa771d4cb0e5613d14edf0db627e8df2a430c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e3c3af5d566fdef096716c867aaa771d4cb0e5613d14edf0db627e8df2a430c"
    sha256 cellar: :any_skip_relocation, sonoma:         "47045e0d430cfda1c3546d1bf62e9727cb0f38296125e3ecfca53ad64f80106b"
    sha256 cellar: :any_skip_relocation, ventura:        "47045e0d430cfda1c3546d1bf62e9727cb0f38296125e3ecfca53ad64f80106b"
    sha256 cellar: :any_skip_relocation, monterey:       "47045e0d430cfda1c3546d1bf62e9727cb0f38296125e3ecfca53ad64f80106b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c298b7033d1a3106b3e09567e1fc81c7f3250d23ab46dba07bf7166562e6b4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthlybuildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), ".cmdearthly"

    generate_completions_from_executable(bin"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}earthly ls")
    assert_match "+mytesttarget", output
  end
end