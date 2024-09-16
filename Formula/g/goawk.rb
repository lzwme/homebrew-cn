class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https:benhoyt.comwritingsgoawk"
  url "https:github.combenhoytgoawkarchiverefstagsv1.28.1.tar.gz"
  sha256 "bed9009c2702fca12fe773e223d9f22bae9a26133d45c523bc3d598b2819b4cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7f3c368b4c6b6b91b46cf08ae9e052b669a953d584b153dbbcb2ee880beaca0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f3c368b4c6b6b91b46cf08ae9e052b669a953d584b153dbbcb2ee880beaca0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7f3c368b4c6b6b91b46cf08ae9e052b669a953d584b153dbbcb2ee880beaca0"
    sha256 cellar: :any_skip_relocation, sonoma:        "522331284a5e39e033d5f766713008037935c6431a255e7fa40ad7ce0daa2af0"
    sha256 cellar: :any_skip_relocation, ventura:       "522331284a5e39e033d5f766713008037935c6431a255e7fa40ad7ce0daa2af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc90363cc4eabd68be88704be71013632bab43ffedb3a4693f27b1cfc637b19"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}goawk '{ gsub(Macro, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end