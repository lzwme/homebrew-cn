class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https:railway.com"
  url "https:github.comrailwayappcliarchiverefstagsv3.22.0.tar.gz"
  sha256 "e8014cad10b3c50004f42151e58603eef9761f6244bc421f156abbe7f9134c39"
  license "MIT"
  head "https:github.comrailwayappcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d0681a89adbd60a943f5f03d08e677fe22dd24f23c60d9a07480794a4f7985"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4754abff10ce32ac124bc5a65e4bfee732ab1a416420fe5afd1d36229b0421db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2eca2fc46eef1818eb0f0057abcc3e7718cc46806630fa6e1551ea09d4be938f"
    sha256 cellar: :any_skip_relocation, sonoma:        "30248e43e4ac799ce8c301deee0044db033dca4ae434075d50bd1f17af101a04"
    sha256 cellar: :any_skip_relocation, ventura:       "71d388510070eb7a11ba4391c457e1b8e26bf6856e4f4d2d01a1fe8bdf925d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ed2b8c6c749bf9b8e716969f1b76dd8ffaf72e5f7d942c328a2ab51fe7e9b6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"railway", "completion")
  end

  test do
    output = shell_output("#{bin}railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}railway --version").chomp
  end
end