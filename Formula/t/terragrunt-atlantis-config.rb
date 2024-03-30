class TerragruntAtlantisConfig < Formula
  desc "Generate Atlantis config for Terragrunt projects"
  homepage "https:github.comtranscend-ioterragrunt-atlantis-config"
  url "https:github.comtranscend-ioterragrunt-atlantis-configarchiverefstagsv1.17.8.tar.gz"
  sha256 "54c3faa5232b6bd494497dc12d9f697114523bab99120a845692d3bf853598e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "18b92b669632d1a2b0ac631d04c76f8907c7fc6e09506d68f7d07c931e1dd719"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b40ed7193a65bd2b471eac0a24f61d481a7eac060c0693e750188a30fb9d0561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d859010dd80dc2344b3f2fa151a12b03ff229c9f791401ec8ca094538865c128"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3fe8d01db6373e9766d7b440ea25f0a810cb062fae217e9063d39b13daad72f"
    sha256 cellar: :any_skip_relocation, ventura:        "6f11f003aa1398b9f8235c39fd992dc620ef86c6c32d27a9c251805da16bea04"
    sha256 cellar: :any_skip_relocation, monterey:       "75e981833b92688522cec2f50f57bc8d66338f0c86af4334e375848fb82c2589"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25b360e08a7d2ceab5fb1a77a4729ec7c5b7a118e8560e42b59995255edf48c0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}terragrunt-atlantis-config generate --root #{testpath} 2>&1")
    assert_match "Could not find an old config file. Starting from scratch", output

    assert_match version.to_s, shell_output("#{bin}terragrunt-atlantis-config version")
  end
end