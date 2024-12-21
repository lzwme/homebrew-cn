class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https:terramate.iodocscli"
  url "https:github.comterramate-ioterramatearchiverefstagsv0.11.5.tar.gz"
  sha256 "39792a2a92111f6dfd9cb1a1ec941facc3a69865d27ac12295a59df9b1c9a88f"
  license "MPL-2.0"
  head "https:github.comterramate-ioterramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b06c7ba1c3c89d4a12d27e3991cbb8534617eee4e3ff1fd59519b2623b2d2ee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06c7ba1c3c89d4a12d27e3991cbb8534617eee4e3ff1fd59519b2623b2d2ee6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b06c7ba1c3c89d4a12d27e3991cbb8534617eee4e3ff1fd59519b2623b2d2ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "37cdc119d3c6c98eb331eed38ef2421b7602009fb09d8c9dd917b9a6e4869afc"
    sha256 cellar: :any_skip_relocation, ventura:       "37cdc119d3c6c98eb331eed38ef2421b7602009fb09d8c9dd917b9a6e4869afc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3ac5004afc6fede28ee89334e376b3c81b2e7c7470cd40af42f69f13b1818a7"
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