class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.10.0.tar.gz"
  sha256 "a3ca90d3eb6fb4aaf116044f4978e70f7c2bc91822b7f3ef972adaf994d64f0f"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a72cd8fe1a440f21d6724f121ca6735dfb7ed09a87a83d5d26036dffd9efc0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34792b652c4d5d203efb0f6f1ced7d893c5d05d38b1464f736acff43f9bec376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c650f2bdd0debac1bc99fbaac7404613eec409c88cc98997d699ea9ed8495b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "0689c33b2bbb83036a88dba9ae53b3a25cc82dac3002eec3e3c5cdd7a4848883"
    sha256 cellar: :any_skip_relocation, ventura:        "40af8ade27f2da7bcbd448e94be49171950746dd4a3c5c3785cbcfbbdc82218e"
    sha256 cellar: :any_skip_relocation, monterey:       "0dd7dcdaeccab741a787bfb24773d95b8b8553cd7c63cb3b59af534eac0cbb62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d96e3e9fa6db1afff58994ada5f6528a92df89f1b4849f446a78e76123c171a5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin"terramate", ldflags: "-s -w"), ".cmdterramate"
    system "go", "build", *std_go_args(output: bin"terramate-ls", ldflags: "-s -w"), ".cmdterramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terramate version")
    assert_match version.to_s, shell_output("#{bin}terramate-ls -version")
  end
end