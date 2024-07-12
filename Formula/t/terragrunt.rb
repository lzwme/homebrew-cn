class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.61.1.tar.gz"
  sha256 "ae09a39443403ce6a2f898110593c248dcfaedc7528315eefe662b671e072e98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2004bf82104c639520165fa63c5f71016d46328a9a6154cfa0d6498a8e0407e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1486d3bea2627bf8a1f0bdad116c5a594103a83e58c58d53c814f602f3c53988"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d3c5298046ce9df90d08365ccdceb3481a75c41e4dfaf6be1471af3741343ac"
    sha256 cellar: :any_skip_relocation, sonoma:         "378bd9abe338d0f3e1572015b115cc0da0cf5f5fa156e8a3b9eedab7614573f0"
    sha256 cellar: :any_skip_relocation, ventura:        "81cec6a2cda2629a45e4bb1d2a58205378cd3e9a21dbef804e889ca8e1f96272"
    sha256 cellar: :any_skip_relocation, monterey:       "aba545d7b6587b7b1269adf9ba518b96dfb4ea2a5fa771dcc1233de2f62d0f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ec93b4d3a2eb0163df6e57ab5a02cf507641475f9bd3d8f8a52ef6a15e35a83"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end