class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https:steampipe.io"
  url "https:github.comturbotsteampipearchiverefstagsv1.0.1.tar.gz"
  sha256 "adb3427982bd950b821b0e67837e3770af787458cbaadb786cdac29ccfd454f8"
  license "AGPL-3.0-only"
  head "https:github.comturbotsteampipe.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89ff0690fb60e5cc3928396bcc0d39440ebee751d34d1fc8c967eac01b60b017"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11ea63ed9f5df3b17026d698c59273e81f0291fa5ce58121c3d0450da0326ff3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "80a338fb5ee3dd18c28ab83a3aff750d4434e3bc756e6ab8ce09a5f8b030dfbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5f0057c2aaa52d000ad48a0e5b5f9bf6302f129c41e076868df53375384cb07"
    sha256 cellar: :any_skip_relocation, ventura:       "6d9a7b9e0a6aefbadc6db1b1f5d50fde7847676858e3c9a0c17c0ebd57301e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216b05ee4abf9ca8388c7e06dda1cb3d34096457d641a838db860fb229933f61"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"steampipe", "completion")
  end

  test do
    if OS.mac?
      output = shell_output(bin"steampipe service status 2>&1", 255)
      assert_match "Error: could not create logs directory", output
    else # Linux
      output = shell_output(bin"steampipe service status 2>&1")
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin"steampipe --version")
  end
end