class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-13.5.0.tgz"
  sha256 "8cd01ac425e5df24fd1d8f96b226ad0582447f87aaa9501dcef5ef9cdf89292a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386c69962f2fa7ae51d2a80333a72c0aad1d3579626e758e4bcbf017ff75508b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4424c96f4570e8c6baf0d9cc9c14f6d7faf213bddb4e7d8d43282ad0a393a528"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4424c96f4570e8c6baf0d9cc9c14f6d7faf213bddb4e7d8d43282ad0a393a528"
    sha256 cellar: :any_skip_relocation, sonoma:        "c04cf8cf80ad52c03a23039630529c613063fe63a2e72b7e90b73f35eb96855c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e6d9d0d889048ec2026fa45fd874650e1fa387b0571bb487ca370ea24f4cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19e6d9d0d889048ec2026fa45fd874650e1fa387b0571bb487ca370ea24f4cd4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/appwrite-cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    output = shell_output("#{bin}/appwrite client --endpoint http://localhost/v1 2>&1", 1)
    assert_match "Error: Invalid endpoint", output

    assert_match version.to_s, shell_output("#{bin}/appwrite --version")
  end
end