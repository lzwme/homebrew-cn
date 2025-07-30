class Stu < Formula
  desc "TUI explorer application for Amazon S3 (AWS S3)"
  homepage "https://github.com/lusingander/stu"
  url "https://ghfast.top/https://github.com/lusingander/stu/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "61cd09c7ad12cc20ff0bd954d6a9f591c0e1dfca6b759dab2aa2c1b7d121c18d"
  license "MIT"
  head "https://github.com/lusingander/stu.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d728f1ea93624c0af13aa6087826f9463f4eb7287294925b60a10e6a53fd3c19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1b8b3ed90a089fce6cc3757819ee75b4192b92bd1ea9f51813a111d3ba9c434"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c54544ed4d9ebc82bf9107b9c6d6cb561a3abaf994cdfa28ea506439bdb14ac2"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c4bc78930d12cdc0e0ea6f22a4ad1dc09cac0516cf1adf4fda2907aa0b6136c"
    sha256 cellar: :any_skip_relocation, ventura:       "f9e2a0932304f3e304e1940c7635a47070da2521c594e533cfb098282e5d56a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08855c2c1c75850b31a195091d2c604f2631b615c1e090f609b2d7e9b051406a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85289acaaffefc89cb0fb2c5f2f7149a191fd99decc6cf92f47bdf39788d3ae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stu --version")

    output = shell_output("#{bin}/stu s3://test-bucket 2>&1", 2)
    assert_match "error: unexpected argument 's3://test-bucket' found", output
  end
end