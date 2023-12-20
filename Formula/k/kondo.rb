class Kondo < Formula
  desc "Save disk space by cleaning non-essential files from software projects"
  homepage "https:github.comtbillingtonkondo"
  url "https:github.comtbillingtonkondoarchiverefstagsv0.8.tar.gz"
  sha256 "4054c90e679a379a735b3166df4633fb86a33725175ebe23d7b659dcb7155b26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d193e9552a2f573b09eaf4d01a5156e2c51743301e1167e2cb94198065308902"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c437e2001ec06e983777a5d1a726fa826475068a64faa58fb33c22dde2ba4561"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9747f6e3a6be8560fb90620b53a3f4c2b317a4b1d60b2901c21ff2d4e587dcf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc5db45fc7fe4211dcedbdf3932dab94e2a36498c8c7c45311da8385bad4ebb3"
    sha256 cellar: :any_skip_relocation, ventura:        "0f379b8636e86b1c7642f462d553bf838628eb1d77801dcb178b867dee20db53"
    sha256 cellar: :any_skip_relocation, monterey:       "0057841619926663972886da4c68941b6e34f70ad6423a37ceb51ede52abb7f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04abab847cf7122c2671cc58ee1fed28c2ec51531584304e97e9e996ef786e23"
  end

  depends_on "rust" => :build

  def install
    # The kondo command line program in in the kondo subfolder, so we navigate there.
    cd "kondo" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "open3"

    # Write a Cargo.toml file so kondo will interpret this directory as a Cargo project.
    (testpath"Cargo.toml").write("")

    # Create a dummy file which we will delete via kondo.
    dummy_artifact_path = (testpath"targetfoo")

    # Write 10 bytes into the dummy file.
    dummy_artifact_path.write("0123456789")

    # Run kondo. It should detect the Cargo.toml file and interpret the directory as a Cargo project.
    # The output should look roughly like the following:
    #
    # privatetmpkondo-test-20200731-55654-i9otaa Cargo project
    #     target (10.0B)
    #   delete above artifact directories? ([y]es, [n]o, [a]ll, [q]uit):
    #
    # We're going to simulate a user pressing "n" for no.
    # The result of this should be that the dummy file still exists after kondo has exited.
    Open3.popen3(bin"kondo") do |stdin, _stdout, _, wait_thr|
      # Simulate a user pressing "n" then pressing returnenter.
      stdin.write("n\n")

      # Wait for the kondo process to exit.
      wait_thr.value

      # Check that the dummy file still exists.
      assert_equal true, dummy_artifact_path.exist?
    end

    # The concept is the same as the above test, except this time we will simulate pressing "y" for yes.
    # The result of this should be that the dummy file still no longer exists after kondo has exited.
    Open3.popen3(bin"kondo") do |stdin, _stdout, _, wait_thr|
      # Simulate a user pressing "y" then pressing returnenter.
      stdin.write("y\n")

      # Wait for the kondo process to exit.
      wait_thr.value

      # Check that the dummy file no longer exists.
      assert_equal false, dummy_artifact_path.exist?
    end
  end
end