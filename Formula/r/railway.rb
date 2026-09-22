class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.59.0.tar.gz"
  sha256 "83d257bc559f6d6081b113d4e61af77f93e584ff792b2bac6a53fb4fdd1e349d"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7460922d9465722f68b8408b629cbf11ec6e894d9b863a9513bf65fba2b047da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aeb6cc5ec93698d968d5b2c585eb3f6794e75a155f38efb7bcc8e7f4c941c896"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf7322f0890e0eb0bd87ce9a8c04fba8ab2b98d9d27aa33f40e624d123064dbe"
    sha256 cellar: :any,                 arm64_linux:       "54bba72634b51123a01d574aa372f799562c0ee24e4e0df1c240e097b9d40236"
    sha256 cellar: :any,                 x86_64_linux:      "00315918cf19d3d45e824b13e20b2ec5c23b9fdbb9f053029055ca6bcfd73205"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end