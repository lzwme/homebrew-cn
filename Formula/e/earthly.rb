class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.8",
      revision: "2718b793272cf8f80fa61071b41fec8469a7427b"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d3f6892cdffa5decb3816497ca6246e755abea83e4cc6b63e26b4145524b8bea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3f6892cdffa5decb3816497ca6246e755abea83e4cc6b63e26b4145524b8bea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d3f6892cdffa5decb3816497ca6246e755abea83e4cc6b63e26b4145524b8bea"
    sha256 cellar: :any_skip_relocation, sonoma:         "480fe1fea1da474594877b7f73b483233c50829cc3090ec74af8003333bfa020"
    sha256 cellar: :any_skip_relocation, ventura:        "480fe1fea1da474594877b7f73b483233c50829cc3090ec74af8003333bfa020"
    sha256 cellar: :any_skip_relocation, monterey:       "480fe1fea1da474594877b7f73b483233c50829cc3090ec74af8003333bfa020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5247b82bb5bc420243700eccfa233edab5b9def0dfff5edeedc51f7e228b3c1c"
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