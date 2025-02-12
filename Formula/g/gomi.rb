class Gomi < Formula
  desc "Functions like rm but with the ability to restore files"
  homepage "https:gomi.dev"
  url "https:github.combabarotgomiarchiverefstagsv1.3.2.tar.gz"
  sha256 "4adfb52f01a860c0248fc63785dc55e2a8cc7e7cb4084f29256d1f14e4524042"
  license "MIT"
  head "https:github.combabarotgomi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "096305bb43da9bc826d8115f213a903d6c3beaa0e835664565891dc5e293f61f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "096305bb43da9bc826d8115f213a903d6c3beaa0e835664565891dc5e293f61f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "096305bb43da9bc826d8115f213a903d6c3beaa0e835664565891dc5e293f61f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f36d7ec6da01f449b95d32e91905314b45bc82b64d02073947374d60d47c4c2"
    sha256 cellar: :any_skip_relocation, ventura:       "2f36d7ec6da01f449b95d32e91905314b45bc82b64d02073947374d60d47c4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8e276210e9d45b12c258473fec36b2d43c013a45734e814909f8544d6b53305"
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