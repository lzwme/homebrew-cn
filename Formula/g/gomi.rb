class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.5.0.tar.gz"
  sha256 "a036ec6bd4695887dc81bf90c3e0b9a36690c2458e010be4f29c867194cbe759"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90f8663b2182855f673f54efb83fbced9d265688b01deee81e5e002a3ed525a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f8663b2182855f673f54efb83fbced9d265688b01deee81e5e002a3ed525a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90f8663b2182855f673f54efb83fbced9d265688b01deee81e5e002a3ed525a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed4e2e967e8c5f9d788033ab27a7cbe29de5cdf374800146169864502a53ec68"
    sha256 cellar: :any_skip_relocation, ventura:       "ed4e2e967e8c5f9d788033ab27a7cbe29de5cdf374800146169864502a53ec68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc584c503e11547eeaa122cefd8c7f237e8e3f8e9c3bf6ab35fcec95d62a25f5"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
      -X main.revision=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # Create a trash directory
    mkdir ".gomi"

    assert_match version.to_s, shell_output("#{bin}gomi --version")

    (testpath"trash").write <<~TEXT
      Homebrew
    TEXT

    # Restoring is done in an interactive prompt, so we only test deletion.
    assert_path_exists testpath"trash"
    system bin"gomi", "trash"
    refute_path_exists testpath"trash"
  end
end