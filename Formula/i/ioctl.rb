class Ioctl < Formula
  desc "Command-line interface for interacting with the IoTeX blockchain"
  homepage "https:docs.iotex.io"
  url "https:github.comiotexprojectiotex-corearchiverefstagsv2.0.7.tar.gz"
  sha256 "b7dae127d5749fcaccfd46f411ebecdff81cb11a817d79c9a1d610dd55ed1112"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c70e48a80bb32e40c399bff76b6656d60ea6a29495072e50596a11f37176113e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef1ca2ffab8abb56070c74b21e2301bae39c98cb8c596696d1788e45887f4a69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "93b0089cef21807d31f4c943e38f68a24aeb76cd73520c7cb7bfa56e3529bad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "b73e5cdb52bbb6ffee7b3e3e004fcbb8245add74903966fa17eaaff98010512f"
    sha256 cellar: :any_skip_relocation, ventura:       "bcce1c9bf42691a4352e6e1f55abbbe6d11e6e7c871f11dae71c024065c13872"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ad6e80442a806c831989c32cf84baca85ed3545dbdf6ce663bc0de5b63b480"
  end

  depends_on "go" => :build

  def install
    system "make", "ioctl"
    bin.install "binioctl"
  end

  test do
    output = shell_output "#{bin}ioctl config set endpoint api.iotex.one:443"
    assert_match "Endpoint is set to api.iotex.one:443", output
  end
end