class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://registry.npmjs.org/ccusage/-/ccusage-15.9.3.tgz"
  sha256 "b555e5d21d8c6f021cd7925861e30514ec8aa951d0e308e130b6a4c142beb5cc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04b1bbc7b733ce092390b0baf8659a6c72b3c231358d7b9f5ad0a84ffb42995b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04b1bbc7b733ce092390b0baf8659a6c72b3c231358d7b9f5ad0a84ffb42995b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "04b1bbc7b733ce092390b0baf8659a6c72b3c231358d7b9f5ad0a84ffb42995b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0a2ffa27bdf901f920883ab4092bd8fd3f680fd3eef7ff6f96c76147d7767ddb"
    sha256 cellar: :any_skip_relocation, ventura:       "0a2ffa27bdf901f920883ab4092bd8fd3f680fd3eef7ff6f96c76147d7767ddb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04b1bbc7b733ce092390b0baf8659a6c72b3c231358d7b9f5ad0a84ffb42995b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04b1bbc7b733ce092390b0baf8659a6c72b3c231358d7b9f5ad0a84ffb42995b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No valid Claude data directories found.", shell_output("#{bin}/ccusage 2>&1", 1)
  end
end