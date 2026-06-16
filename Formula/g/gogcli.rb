class Gogcli < Formula
  desc "Google Suite CLI"
  homepage "https://gogcli.sh"
  url "https://ghfast.top/https://github.com/steipete/gogcli/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "9a58d27d181133feaf8a7f97717f5eb7acb91b18ade54486c88410d103377210"
  license "MIT"
  head "https://github.com/steipete/gogcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64cb81ac568519def159dc7c3bf646005df795f8b6ee0fbbe033d2a46e5c9aa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fbf03ff24f885fd9cb548454bf34c4b3f26ee613c533deecc6d054ce829fb7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eeb84652924f9a761bedafd32c2fed79badcdecc53c56401e5c0ab9745893a8d"
    sha256 cellar: :any_skip_relocation, sonoma:        "21ae5eac299423adc11257b588c54dce7783ead0f677e197f16c30e388caf2b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0fd5633a2773b51e6663df1ff2d34ad85efd3eb9b2596cf8f8befa817645d6f4"
    sha256 cellar: :any,                 x86_64_linux:  "af6b9a4c7f6eed9ec1c9bde30c517be8bbb4bd70c8dba5c9f0b2595c763e1416"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{tap.user}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"gog"), "./cmd/gog"

    generate_completions_from_executable(bin/"gog", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gog --version")

    ENV["GOG_ACCOUNT"] = "example@example.com"
    output = shell_output("#{bin}/gog drive ls 2>&1", 10)
    assert_match "OAuth client credentials missing", output
  end
end