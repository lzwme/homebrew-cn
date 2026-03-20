class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-15.1.0.tgz"
  sha256 "fbd3102d01d1dd8cecb0ed12b269017dc3e0e9870696d62ee54d3e34956461aa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05a58e34dd8873ff90ce5d84f81b9500c9da212ed96290efe7cfef125209ec82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4fb0fe399f4bc580ad2522747f5190b64933e22eb703747bb13be920df6190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce4fb0fe399f4bc580ad2522747f5190b64933e22eb703747bb13be920df6190"
    sha256 cellar: :any_skip_relocation, sonoma:        "709e5ac706e702ccb3dd396f0c57b1acbadeb15d08de1b3a85fb721fc9fd97d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22f90910910b037b59fefb14cde11955b420b1aed46771254f16766444422424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22f90910910b037b59fefb14cde11955b420b1aed46771254f16766444422424"
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