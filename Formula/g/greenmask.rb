class Greenmask < Formula
  desc "PostgreSQL dump and obfuscation tool"
  homepage "https:greenmask.io"
  url "https:github.comGreenmaskIOgreenmaskarchiverefstagsv0.2.2.tar.gz"
  sha256 "e0a92951977f121432fd6c6696b4e136734ab46dcfc79329c4445587d2ff6076"
  license "Apache-2.0"
  head "https:github.comGreenmaskIOgreenmask.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f632a2d9b5b9cc9a0bd0636f4bf83f0fef9f22a69325dcd0f3a3df95b7937a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f632a2d9b5b9cc9a0bd0636f4bf83f0fef9f22a69325dcd0f3a3df95b7937a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f632a2d9b5b9cc9a0bd0636f4bf83f0fef9f22a69325dcd0f3a3df95b7937a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "3577b9aea2b99a104f91d46abdb24d8bbb5cb06a6f3cfa631cc87a0ad9cf83bf"
    sha256 cellar: :any_skip_relocation, ventura:       "3577b9aea2b99a104f91d46abdb24d8bbb5cb06a6f3cfa631cc87a0ad9cf83bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e334283645ff09f5dd6d56f80d6b5196552861779c23a428d552b7552ac0cd0c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgreenmaskiogreenmaskcmdgreenmaskcmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdgreenmask"

    generate_completions_from_executable(bin"greenmask", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}greenmask -v")

    (testpath"config.yml").write <<~YAML
      common:
        pg_bin_path: "usrlibpostgresql16bin"
        tmp_dir: "tmp"

      storage:
        s3:
          endpoint: "http:playground-storage:9000"
          bucket: "adventureworks"
          region: "us-east-1"
          access_key_id: "Q3AM3UQ867SPQQA43P2F"
          secret_access_key: "zuf+tfteSlswRu7BJ86wekitnifILbZam1KYY3TG"

      validate:
      #  resolved_warnings:
      #    - "aa808fb574a1359c6606e464833feceb"

      dump:
        pg_dump_options: # pg_dump option that will be provided
          dbname: "host=playground-db user=postgres password=example dbname=original"
          jobs: 10

        transformation: # List of tables to transform
          - schema: "humanresources" # Table schema
            name: "employee"  # Table name
            transformers: # List of transformers to apply
              - name: "NoiseDate" # name of transformers
                params: # Transformer parameters
                  ratio: "10 year 9 mon 1 day"
                  column: "birthdate" # Column parameter - this transformer affects scheduled_departure column

      restore:
        pg_restore_options: # pg_restore option (you can use the same options as pg_restore has)
          jobs: 10
          dbname: "host=playground-db user=postgres password=example dbname=transformed"
    YAML

    output = shell_output("#{bin}greenmask --config config.yml list-transformers")
    assert_match "Generate UUID", output
    assert_match "Generates a random word", output
  end
end