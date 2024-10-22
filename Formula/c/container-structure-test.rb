class ContainerStructureTest < Formula
  desc "Validate the structure of your container images"
  homepage "https:github.comGoogleContainerToolscontainer-structure-test"
  url "https:github.comGoogleContainerToolscontainer-structure-testarchiverefstagsv1.19.2.tar.gz"
  sha256 "5d4c64c5132c0942dbed912fe0104447a9f4b871c9d6b448d3053196a9ac7de0"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolscontainer-structure-test.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37b5ffb011044e738449f54cd6b95f3509f2adab2d3026c88e207c3a64a19715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b5ffb011044e738449f54cd6b95f3509f2adab2d3026c88e207c3a64a19715"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "37b5ffb011044e738449f54cd6b95f3509f2adab2d3026c88e207c3a64a19715"
    sha256 cellar: :any_skip_relocation, sonoma:        "58383363524071f98c248acc9ca9d1a55201316f2d4b8de4f0054540c2b3aef7"
    sha256 cellar: :any_skip_relocation, ventura:       "58383363524071f98c248acc9ca9d1a55201316f2d4b8de4f0054540c2b3aef7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07229f418ea454881c3d64114d502a23dadfe7ce28f9946c7bced3a774892e9"
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