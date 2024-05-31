class Juju < Formula
  desc "DevOps management tool"
  homepage "https:juju.is"
  url "https:launchpad.netjuju3.53.5.1+downloadjuju-core_3.5.1.tar.gz"
  sha256 "0497fd4c9f81f160afbd5caee1b0ca86e00fc706a15a2e659c23af0722e8e452"
  license "AGPL-3.0-only"
  version_scheme 1
  head "https:github.comjujujuju.git", branch: "develop"

  # We check the Launchpad download page for Juju because the latest version
  # listed on the main project page isn't always a stable version.
  livecheck do
    url "https:launchpad.netjuju+download"
    regex(href=.*?juju-core[._-]v?(\d+(?:\.\d+)+)\.ti)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b7387a820a40455821060b0c98ea2579f55ee0d18b1908b4683c49b73e1687a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d0ebc3e2c89ad21fa5e1e1474e817e27df6c83b29a616f11cc763660e7efaf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ceb4029b0bf50c9f613a838a62706919f2213606b7e645b7a3c185e7d1b5c0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1cffc5eda46361a27df8582b8bd7f856d29f40c36dd64271f63d60e0a090701"
    sha256 cellar: :any_skip_relocation, ventura:        "45f69c55e242597406a718e0d59e6633c0ff7baa2cb398cf48fe5d1feaa58f43"
    sha256 cellar: :any_skip_relocation, monterey:       "63708f9e7633bd1a108417ad8ca08fdf8761a940653efd322450134e2fe368eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a02aad5bf7cf6aab330944a10c18f961e5eaa3b2ab38c8767d7c088834a7b78"
  end

  depends_on "go" => :build

  def install
    cd "srcgithub.comjujujuju" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdjuju"
      system "go", "build", *std_go_args(output: bin"juju-metadata", ldflags: "-s -w"), ".cmdpluginsjuju-metadata"
      bash_completion.install "etcbash_completion.djuju"
    end
  end

  test do
    system "#{bin}juju", "version"
    assert_match "No controllers registered", shell_output("#{bin}juju list-users 2>&1", 1)
    assert_match "No controllers registered", shell_output("#{bin}juju-metadata list-images 2>&1", 2)
  end
end