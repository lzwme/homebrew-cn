class Cog < Formula
  desc "Containers for machine learning"
  homepage "https://github.com/replicate/cog"
  url "https://ghproxy.com/https://github.com/replicate/cog/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "c8d47a14e069d6683b2952e60343a2bce24439fc65cce6c8a8806c7b63228d33"
  license "Apache-2.0"
  head "https://github.com/replicate/cog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69ff35252593fce7e34e37e7067e277f935187368d66d770e178e6a835863bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ed5fdd590c1c7b451a709a7d85ddba8fe743cd1924f986f7f0969721af4506"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e33a30cad3b3df8854894056f873aabe15f0e922017624f8a734b05bc59f31b"
    sha256 cellar: :any_skip_relocation, ventura:        "87769fa73fc60ce29e03a7515630dbc8e8be2cea9d47d59b3ccd6b46f234963a"
    sha256 cellar: :any_skip_relocation, monterey:       "a4937a694e1c3ab18ecb645c03524e19d2ce794f6bc553302e36a76eac24b89a"
    sha256 cellar: :any_skip_relocation, big_sur:        "382f82524e4e81b4f955a9b266bc462aac136fe26fc34b6cb6c1502241ae49ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c24a9dfd4db7cace88ecedee146d4c20eb1d9fad799bcc34947d3a94ff810bec"
  end

  depends_on "go" => :build

  uses_from_macos "python" => :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
    system "make", "COG_VERSION=#{version}", "PYTHON=python3"
    bin.install "cog"
    generate_completions_from_executable(bin/"cog", "completion")
  end

  test do
    assert_match "cog version #{version}", shell_output("#{bin}/cog --version")
    assert_match "cog.yaml not found", shell_output("#{bin}/cog build 2>&1", 1)
  end
end