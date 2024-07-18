class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https:github.comGoogleContainerToolscontainer-structure-test"
  url "https:github.comGoogleContainerToolscontainer-structure-testarchiverefstagsv1.19.0.tar.gz"
  sha256 "fa9d2a1e6b626b331a9830276a8ea96a8013e1652546dd553863308a270457b3"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolscontainer-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "72331e49cd211ce8bd5151a38ffa538ae4853e00f6c99842bed5ed13819b2297"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58b2c45687cf8a5f46e4f58762ab324e3ab7129262963491ebf3dc1c854173bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c32a65364765bec3b3f2f106ddf25d8a32f13e66ab010aa19fcbe73babd18577"
    sha256 cellar: :any_skip_relocation, sonoma:         "232c9478fcc68edd418808f12ea804fc12884caa6fa148388be8c026612b8390"
    sha256 cellar: :any_skip_relocation, ventura:        "345e3d5b10d06ec895bba7fbc065f7ef35c6b0271d548bfc02f6b7df939209ef"
    sha256 cellar: :any_skip_relocation, monterey:       "fabbe847882bee3211f9973bb0099067d0071be8526023585e6107d3dea07f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aebec8e924a4ad803265b2480aeee5c5f4bfd1785d389249aae897ee25d193f"
  end

  depends_on "go" => :build

  def install
    project = "github.comGoogleContainerToolscontainer-structure-test"
    ldflags = %W[
      -s -w
      -X #{project}pkgversion.version=#{version}
      -X #{project}pkgversion.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdcontainer-structure-test"
  end

  test do
    # Small Docker image to run tests against
    resource "homebrew-test_resource" do
      url "https:gist.github.comAndiDog1fab301b2dbc812b1544cd45db939e94raw5160ab30de17833fdfe183fc38e4e5f69f7bbae0busybox-1.31.1.tar", using: :nounzip
      sha256 "ab5088c314316f39ff1d1a452b486141db40813351731ec8d5300db3eb35a316"
    end

    (testpath"test.yml").write <<~EOF
      schemaVersion: "2.0.0"

      fileContentTests:
        - name: root user
          path: "etcpasswd"
          expectedContents:
            - "root:x:0:0:root:root:binsh\\n.*"

      fileExistenceTests:
        - name: Basic executable
          path: bintest
          shouldExist: yes
          permissions: '-rwxr-xr-x'
    EOF

    args = %w[
      --driver tar
      --json
      --image busybox-1.31.1.tar
      --config test.yml
    ].join(" ")

    resource("homebrew-test_resource").stage testpath
    json_text = shell_output("#{bin}container-structure-test test #{args}")
    res = JSON.parse(json_text)
    assert_equal res["Pass"], 2
    assert_equal res["Fail"], 0
  end
end