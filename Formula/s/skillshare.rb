class Skillshare < Formula
  desc "Sync skills across AI CLI tools"
  homepage "https://skillshare.runkids.cc"
  url "https://ghfast.top/https://github.com/runkids/skillshare/archive/refs/tags/v0.20.12.tar.gz"
  sha256 "53560c620873103632db4502815ef24ce31611a38951ab4b0ca806a1693762b5"
  license "MIT"
  head "https://github.com/runkids/skillshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aead37541b09b51bcff2e8d529dd0ee920f5a9b0c4dab5a4d8c20d32cfa2976e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aead37541b09b51bcff2e8d529dd0ee920f5a9b0c4dab5a4d8c20d32cfa2976e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aead37541b09b51bcff2e8d529dd0ee920f5a9b0c4dab5a4d8c20d32cfa2976e"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e89e01372eaeefe223024a9061e81d8caea456284b2913125129c79b4cfc79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae18112aea1fd7aa9bab3c5e08dbec1d966b07fc480be1af3ad87fdcc0a5dd61"
    sha256 cellar: :any,                 x86_64_linux:  "bc5bbdf823d163b2d48b26e08457f116178a18115dfca05d207c3dd6074ebb5b"
  end

  depends_on "go" => :build

  def install
    # Avoid building web UI
    ui_path = "internal/server/dist"
    mkdir_p ui_path
    (buildpath/"#{ui_path}/index.html").write "<!DOCTYPE html><html><body><h1>UI not built</h1></body></html>"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/skillshare"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skillshare version")

    assert_match "config not found", shell_output("#{bin}/skillshare sync 2>&1", 1)
  end
end