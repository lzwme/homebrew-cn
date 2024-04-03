class Scw < Formula
  desc "Command-line Interface for Scaleway"
  homepage "https:github.comscalewayscaleway-cli"
  url "https:github.comscalewayscaleway-cliarchiverefstagsv2.29.0.tar.gz"
  sha256 "851901d481358c04bc66610402ec789087f4f70cf7d44830fd2f39dfb8d9f1c8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28451d3147fa36d1779cc1fb69e5cc61f3be792aabc4134e1c3107e20312bc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4cea743cbfa4cd368928b6d1b0b66df22b0f4e8a9dd78b4e9e65813c086fe1c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b27ba3da60ce7b0a8613f53a5a226442c67f825d7754223bdd8ab2a9849d460d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0c54d49f2f2b19171f7bf2f6ea7fa35e306ec255e666989416ae2a824ceb2aa"
    sha256 cellar: :any_skip_relocation, ventura:        "9d7c6881f2c7ffbcce781b320c762d341a17a79f9652fdc2dca788e83fa75092"
    sha256 cellar: :any_skip_relocation, monterey:       "1c179812db46b3d2b0ba48162716d82d6dd63b38c5c12db429e0b9eec1d3aa34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "346b03819864b95a0b16901482c50f01875d4db4a4dde9ddcc69313264a0152b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), ".cmdscw"

    generate_completions_from_executable(bin"scw", "autocomplete", "script", shell_parameter_format: :none)
  end

  test do
    (testpath"config.yaml").write ""
    output = shell_output(bin"scw -c config.yaml config set access-key=SCWXXXXXXXXXXXXXXXXX")
    assert_match "✅ Successfully update config.", output
    assert_match "access_key: SCWXXXXXXXXXXXXXXXXX", File.read(testpath"config.yaml")
  end
end