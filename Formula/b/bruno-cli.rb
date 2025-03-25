class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https:www.usebruno.com"
  url "https:registry.npmjs.org@usebrunocli-cli-1.40.0.tgz"
  sha256 "45fbf48ab4ce650c7a7cc77b9c1c587ba7e5d29870f464052a44d45b62fcddb0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c066ce9a01894c7727d406cc4ead3084995df0d234df974f6439cfbd3037d809"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c066ce9a01894c7727d406cc4ead3084995df0d234df974f6439cfbd3037d809"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c066ce9a01894c7727d406cc4ead3084995df0d234df974f6439cfbd3037d809"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcf188d450c9bfbb962cd2f4a9af1dfaf0e5c23fda52be434aafb0658b90418a"
    sha256 cellar: :any_skip_relocation, ventura:       "dcf188d450c9bfbb962cd2f4a9af1dfaf0e5c23fda52be434aafb0658b90418a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c066ce9a01894c7727d406cc4ead3084995df0d234df974f6439cfbd3037d809"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c066ce9a01894c7727d406cc4ead3084995df0d234df974f6439cfbd3037d809"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https:github.comusebrunobrunoissues2229
    (bin"bru").write_env_script libexec"binbru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}bru run 2>&1", 4)
  end
end