class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://ghfast.top/https://github.com/railwayapp/cli/archive/refs/tags/v5.27.1.tar.gz"
  sha256 "ddeddb9ea869d8a7a57f216c771ae2cb47ef5aba694114192ebee803d3760758"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73146f1f39b831c50f6060be2238619e44ecf917ef55308e427db9abade61c95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e4c995668f2b84447e6d19cf8ddb0ec52f638b6d916dda81c4c178d6dfdb032"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba40743bde0f98b4a5b2d412d9f475d6bb65d8196a56ce96ee9a977465e6f2e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "febf684160aa2e5fc27042c7773712c882fd8e44b942f187192a4188404eeffa"
    sha256 cellar: :any,                 arm64_linux:   "4860788fe08892446cb3f0259d7fc16d90e7c31cf0791ffa76550ba99782cee3"
    sha256 cellar: :any,                 x86_64_linux:  "cf79831283c055b9a3e37f09dc4faab5cf8bcf6791a85f1cc1ab18c953f670e0"
  end

  depends_on "rust" => :build

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