class Borgmatic < Formula
  include Language::Python::Virtualenv

  desc "Simple wrapper script for the Borg backup software"
  homepage "https:torsion.orgborgmatic"
  url "https:files.pythonhosted.orgpackages8de4098ca9ab91fd59a7198007b463abb7c60680f83a47703babc13ee74b62ddborgmatic-1.9.0.tar.gz"
  sha256 "6a099c743cf29787909d65c26ab6214318f5e7edc343958c839cc5ec520556fc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4ecf8b39920ea72a1f225fe7cc230488ecddea13dd9b88533005f2e2004e0c52"
    sha256 cellar: :any,                 arm64_sonoma:  "226a550c27455ca672b7dcb80c21e99e3e986907710e6f1f73b2e98e06599983"
    sha256 cellar: :any,                 arm64_ventura: "22438f52022d945c7a014014dde1f40efcec6fb1642489eb0681e7463eaf800f"
    sha256 cellar: :any,                 sonoma:        "80cd901cab1191e07aa121c3447de218b6588deaa3e894e391d230dc7f46fbf0"
    sha256 cellar: :any,                 ventura:       "1084376a74bdf855b934c9c3cc9788bdf0c92bdfe4f0801538899590a6a112c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c60a2ef03c2f98f83fdabf49b2cc9a24ad926bb1e44c513f50096b1040eb3f9f"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "python@3.13"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagesfc0faafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fbattrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages25cb8e919951f55d109d658f81c9b49d0cc3b48637c50792c5d2e77032b8c5darpds_py-0.20.1.tar.gz"
    sha256 "e1791c4aabd117653530dccd24108fa03cc6baf21f58b950d0a73c3b3b29a350"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages29814dfc17eb6ebb1aac314a3eb863c1325b907863a1b8b1382cdffcb6ac0ed9ruamel.yaml-0.18.6.tar.gz"
    sha256 "8b27e6a217e786c6fbe5634d8f3f11bc63e0f80f6a5890f28863d9c45aac311b"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  # upstream patch ref, https:projects.torsion.orgborgmatic-collectiveborgmaticcommitbe08e889f00beda6858070becf96ae552334d473
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesfa4f1fe3e40198e8425fe80c79891f9cf947765dborgmatic1.9.0.patch"
    sha256 "6bbb02832d46f6438bd8b1b75206d88da88d7d450e35cb6e3b1d61bcf19b9027"
  end

  def python3
    "python3.13"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resource("setuptools")
    venv.pip_install resources.reject { |r| r.name == "setuptools" }
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["TMPDIR"] = testpath

    borg = (testpath"borg")
    borg_info_json = (testpath"borg_info_json")
    config_path = testpath"config.yml"
    repo_path = testpath"repo"
    log_path = testpath"borg.log"
    sentinel_path = testpath"init_done"

    # Create a fake borg info json
    borg_info_json.write <<~EOS
      {
          "cache": {
              "path": "",
              "stats": {
                  "total_chunks": 0,
                  "total_csize": 0,
                  "total_size": 0,
                  "total_unique_chunks": 0,
                  "unique_csize": 0,
                  "unique_size": 0
              }
          },
          "encryption": {
              "mode": "repokey-blake2"
          },
          "repository": {
              "id": "0000000000000000000000000000000000000000000000000000000000000000",
              "last_modified": "2022-01-01T00:00:00.000000",
              "location": "#{repo_path}"
          },
          "security_dir": ""
      }
    EOS

    # Create a fake borg executable to log requested commands
    borg.write <<~EOS
      #!binsh
      echo $@ >> #{log_path}

      # return valid borg version
      if [ "$1" = "--version" ]; then
        echo "borg 1.2.0"
        exit 0
      fi

      # for first invocation only, return an error so init is called
      if [ "$1" = "info" ]; then
        if [ -f #{sentinel_path} ]; then
          # return fake repository info
          cat #{borg_info_json}
          exit 0
        else
          touch #{sentinel_path}
          exit 2
        fi
      fi

      # skip actual backup creation
      if [ "$1" = "create" ]; then
        exit 0
      fi
    EOS
    borg.chmod 0755

    # Generate a config
    system bin"borgmatic", "config", "generate", "--destination", config_path

    # Replace defaults values
    inreplace config_path do |s|
      s.gsub! "- varlogsyslog*", ""
      s.gsub! "- homeuserpath with spaces", ""
      s.gsub! "- path: ssh:user@backupserver.sourcehostname.borg", "- path: #{repo_path}"
      s.gsub! "- path: mntbackup", ""
      s.gsub!(# ?local_path: borg1, "local_path: #{borg}")
    end

    # Initialize Repo
    system bin"borgmatic", "-v", "2", "--config", config_path, "init", "--encryption", "repokey"

    # Create a backup
    system bin"borgmatic", "--config", config_path

    # See if backup was created
    system bin"borgmatic", "--config", config_path, "--json"

    # Read in stored log
    log_content = File.read(log_path)

    # Assert that the proper borg commands were executed
    assert_equal <<~EOS, log_content
      --version --debug --show-rc
      info --json #{repo_path}
      init --encryption repokey --debug #{repo_path}
      --version
      create #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} etc home #{testpath}.borgmatic #{config_path}
      prune --keep-daily 7 --glob-archives {hostname}-* #{repo_path}
      compact #{repo_path}
      info --json #{repo_path}
      check --glob-archives {hostname}-* #{repo_path}
      --version
      create --json #{repo_path}::{hostname}-{now:%Y-%m-%dT%H:%M:%S.%f} etc home #{testpath}.borgmatic #{config_path}
      prune --keep-daily 7 --glob-archives {hostname}-* #{repo_path}
      compact #{repo_path}
      info --json #{repo_path}
    EOS
  end
end