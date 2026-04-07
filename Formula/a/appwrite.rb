class Appwrite < Formula
  desc "Command-line tool for Appwrite"
  homepage "https://appwrite.io"
  url "https://registry.npmjs.org/appwrite-cli/-/appwrite-cli-17.3.0.tgz"
  sha256 "820fd26eca6eaee6e855b9df385c3a4537b2a2cf8d3673adde7518e2015204cb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ccad5b135f4d5af72b66f0689c64eeedc493159c039bb6477019dba93f76bb52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd14538ac97cd29880f3321d69d3c5d3ad1f54c4b21d488c7c547351b6e41f32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd14538ac97cd29880f3321d69d3c5d3ad1f54c4b21d488c7c547351b6e41f32"
    sha256 cellar: :any_skip_relocation, sonoma:        "1078e1a6ce31055577250c2df6f6beaa30080f35ab5056b7e96d55723e3bfeb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466ab505d24616cd27864bd21d098f2b8f6b996e0454c437dc144346fa8fb224"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "466ab505d24616cd27864bd21d098f2b8f6b996e0454c437dc144346fa8fb224"
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