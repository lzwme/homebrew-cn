class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https:pulumi.io"
  url "https:github.compulumipulumi.git",
      tag:      "v3.153.0",
      revision: "252e8800fb920627e66e8bf586b27ccbb80a505f"
  license "Apache-2.0"
  head "https:github.compulumipulumi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f11c3ef00d683b27cca312c53a3dedf774f2a01ed01b60185ec93f3b09d19394"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88bb0dfddec1925d3530229e2fe37ab8571ade209aec2d32d5f71f9e8cc9685d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a217fb57b71e550ea74570a9c432f70c24c074435c0774ee8347163a867c985"
    sha256 cellar: :any_skip_relocation, sonoma:        "32f05ff29f3eb5019682ad112693604e1881d36ce872d8ba02777f83fc8ba98f"
    sha256 cellar: :any_skip_relocation, ventura:       "23836c31994d825c0a375df99b4f017ddfb8d8669928867d9d305547cef0f32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d072b4aa991e1c1ce4282f22ea13de62dec58b4c1506ee6fa71058537f5df146"
  end

  depends_on "go" => :build

  def install
    cd ".sdk" do
      system "go", "mod", "download"
    end
    cd ".pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}binpulumi*"]

    # Install shell completions
    generate_completions_from_executable(bin"pulumi", "gen-completion")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local:"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath"templates"
    system bin"pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_path_exists testpath"Pulumi.yaml", "Project was not created"
  end
end