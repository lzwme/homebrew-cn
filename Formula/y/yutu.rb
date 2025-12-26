class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://ghfast.top/https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "7d0b4f69b75119f619cdbb4fe565a7c22c0b178de5d2a132fbe05ad80d3ccc14"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6e6217febb5e757b2b8d685a914bd00c8f214595e8fc15ef84159bf92599e62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6e6217febb5e757b2b8d685a914bd00c8f214595e8fc15ef84159bf92599e62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6e6217febb5e757b2b8d685a914bd00c8f214595e8fc15ef84159bf92599e62"
    sha256 cellar: :any_skip_relocation, sonoma:        "88deb0aa2dc6edac98d66155b2f68aac3e68ff3446baedafbe927614b6830eda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56f5fc57b17afbb4341f968fb7f82891fd49b74d0cba6a9bf5d0f6bda72a7a5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bbeeb2da222207e460ef202b4df07ddf5f47faa0bae72b22e1ec490f3148e9a"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
      -s -w
      -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
      -X #{mod}.Arch=#{Hardware::CPU.arch}
      -X #{mod}.Version=v#{version}
      -X #{mod}.CommitDate=#{time.iso8601}
      -X #{mod}.Builder=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yutu", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yutu version 2>&1")

    assert_match "failed to parse client secret", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end