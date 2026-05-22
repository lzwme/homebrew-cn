class Filebrowser < Formula
  desc "Web File Browser"
  homepage "https://filebrowser.org/"
  url "https://ghfast.top/https://github.com/filebrowser/filebrowser/archive/refs/tags/v2.63.5.tar.gz"
  sha256 "440d58f5db2d75974ad751ae3e1458f9f407a247f5eaa58cbd01b64cf077ab1e"
  license "Apache-2.0"
  head "https://github.com/filebrowser/filebrowser.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f77efb77d4671cc6d5b6f97498fcb4da1c8a7cd5018444464f9db010d705e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "867741dc979e5b99f18ea716d7dabfbb0faedbbd352256ff678fd67f6fbb000e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1670e25ace37459e6e416a5a393986775f726b5be20a8c129eee4f299d7c6469"
    sha256 cellar: :any_skip_relocation, sonoma:        "b8fef8c9b4380440f024c5e2ce492c3ab0fcbfa67058ae18415dc45d4db3d75d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7210ec81b81eda76e592a07d255d295aeb62c8b96c3dfec2c499f77b947f78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5a3584c21fe1ea510ea150b06819d17ac75072d23eed38d46fd737387a4a39"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/filebrowser/filebrowser/v2/version.Version=#{version}
      -X github.com/filebrowser/filebrowser/v2/version.CommitSHA=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"filebrowser", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/filebrowser version")

    system bin/"filebrowser", "config", "init"
    assert_path_exists testpath/"filebrowser.db"

    output = shell_output("#{bin}/filebrowser config cat 2>&1")
    assert_match "Using database: #{testpath}/filebrowser.db", output
  end
end