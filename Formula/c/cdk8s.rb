class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https:cdk8s.io"
  url "https:registry.npmjs.orgcdk8s-cli-cdk8s-cli-2.200.36.tgz"
  sha256 "e98c57a4f6b4639ea65a7e136b6554a279ebeac56a3ca56827c8b89f6eede4fb"
  license "Apache-2.0"
  head "https:github.comcdk8s-teamcdk8s-cli.git", branch: "2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2410bc2f13ff0d4379cf27a50bc8768dc93266520fda9b839a27c3c0aca3da02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2410bc2f13ff0d4379cf27a50bc8768dc93266520fda9b839a27c3c0aca3da02"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2410bc2f13ff0d4379cf27a50bc8768dc93266520fda9b839a27c3c0aca3da02"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4f71790862f316eec6ef6208cf920e8942afe1cbed0e15505130343747bb7bd"
    sha256 cellar: :any_skip_relocation, ventura:       "c4f71790862f316eec6ef6208cf920e8942afe1cbed0e15505130343747bb7bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2410bc2f13ff0d4379cf27a50bc8768dc93266520fda9b839a27c3c0aca3da02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2410bc2f13ff0d4379cf27a50bc8768dc93266520fda9b839a27c3c0aca3da02"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    output = shell_output("#{bin}cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end