class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https:www.neosync.dev"
  url "https:github.comnucleuscloudneosyncarchiverefstagsv0.3.50.tar.gz"
  sha256 "9bd6f8c948bf097b1cc0cc64825019312f5a05805b45f5bca5d469fd3e5f9b69"
  license "MIT"
  head "https:github.comnucleuscloudneosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68fe44b797a6362bd223de91a0b2eab46a4baef034887ab7777498c477d8644e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5685d86daf0af2ddfd5d38d05cd6eb441003636fd981515254762abd72466082"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4dcea8e9d7ce98e2c7d87a09a6436ef233e4505e61c9f9d4a30d8008924c8d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3412698c9ec15c76b4b89f831bae7f9b6a95b5ada094375ecd1b0535f0bff55f"
    sha256 cellar: :any_skip_relocation, ventura:        "694ec5fe1bcd1911f627b8f4b7196a0323a3c53408b7a8ed6c9654efaa9f26e5"
    sha256 cellar: :any_skip_relocation, monterey:       "63374362f0031fb5c56e95a5a8ea34102903b24eed47a251205fb38c94b8bb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b79a987ef02416f1693daa48175e571dd1bb653f67d1c04be520d52fb9c3249e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comnucleuscloudneosynccliinternalversion.gitVersion=#{version}
      -X github.comnucleuscloudneosynccliinternalversion.gitCommit=#{tap.user}
      -X github.comnucleuscloudneosynccliinternalversion.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), ".cmdneosync"
    end

    generate_completions_from_executable(bin"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}neosync --version")
  end
end