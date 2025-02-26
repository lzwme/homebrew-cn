class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https:github.comtickstepaliyunpan"
  url "https:github.comtickstepaliyunpanarchiverefstagsv0.3.6.tar.gz"
  sha256 "8ed4222479ef72f7b63e64a851804a6a9ddb917c20026cdc1255ff0450c1a251"
  license "Apache-2.0"
  head "https:github.comtickstepaliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7952f16aef1b0732fe945a15673e60d6e661a73646a2d80e2daa77b5042c895d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7952f16aef1b0732fe945a15673e60d6e661a73646a2d80e2daa77b5042c895d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7952f16aef1b0732fe945a15673e60d6e661a73646a2d80e2daa77b5042c895d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4e12ca6857751295764e6a1d009b97d67093c7a8b1c88e95ea481928326eca5"
    sha256 cellar: :any_skip_relocation, ventura:       "b4e12ca6857751295764e6a1d009b97d67093c7a8b1c88e95ea481928326eca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60d85d5ad6f367d5e06dbb2128d157a1a3db9f3af1974e3c89b80b1c92a169e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"aliyunpan", "run", "touch", "output.txt"
    assert_path_exists testpath"output.txt"
  end
end